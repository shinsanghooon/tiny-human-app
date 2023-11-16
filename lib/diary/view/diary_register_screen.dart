import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../common/component/alert_dialog.dart';
import '../../common/component/custom_long_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import 'diary_screen.dart';

class DiaryRegisterScreen extends StatefulWidget {
  const DiaryRegisterScreen({super.key});

  @override
  State<DiaryRegisterScreen> createState() => _DiaryRegisterScreenState();
}

class _DiaryRegisterScreenState extends State<DiaryRegisterScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();
  final List<Widget> _formWidgets = [];

  // profile image
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  XFile? pickedFile;
  List<XFile>? pickedFiles;
  String? pickedFilePath;

  String? name;
  String? nickname;

  int? daysAfterBirth;

  DateTime? diaryDate;
  List<String> fileName = [];
  List<String> sentences = [];

  String? accessToken;

  @override
  void initState() {
    super.initState();
    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();
    diaryDate = DateTime.now();
    calculateDaysAfterBirth(diaryDate!);
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  void calculateDaysAfterBirth(DateTime selectedDate) {
    final birthday = DateTime(2022, 9, 27);
    daysAfterBirth = selectedDate.difference(birthday).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: diaryAppBar(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Icon(
                  Icons.photo_outlined,
                  size: 80.0,
                ),
                color: Colors.deepOrange.shade500,
              ),
              const SizedBox(height: 20.0),
              Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          datePickerButton(context),
                          const SizedBox(width: 14.0),
                          if (daysAfterBirth != null)
                            Text(
                              '+${daysAfterBirth.toString()}일',
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                                fontSize: 20.0,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      // 기존 입력 폼 목록 표시
                      Column(
                        children: _formWidgets,
                      ),
                      // + 버튼
                      if (_formWidgets.length < 3)
                        TextButton(
                          onPressed: () {
                            // + 버튼 클릭 시 새로운 입력 폼 추가
                            if (_formWidgets.length >= 3) {
                              throw Exception("최대 3개까지만 입력이 가능합니다.");
                            }
                            _addNewForm(_formWidgets.length + 1);
                          },
                          child: Icon(
                            Icons.add,
                            color: PRIMARY_COLOR,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              width: 0.5,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20.0),
                      registerDiaryActionButton(context),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // 새로운 입력 폼 추가
  void _addNewForm(int id) {
    setState(() {
      _formWidgets.add(_buildFormWidget(id));
    });
  }

  // 입력 폼 위젯 생성
  Widget _buildFormWidget(int id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "#$id",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.start,
        ),
        Container(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomLongTextFormField(
              keyName: 'description_$id',
              onSaved: (String? value) {
                sentences.add(value!);
              },
              hintText: "아기의 오늘을 남겨주세요.",
              initialValue: '',
            ),
          ),
        ),
      ],
    );
  }

  SizedBox registerDiaryActionButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      child: ElevatedButton(
        onPressed: () async {
          // 서버에 요청을 보낸다.
          print('---------- Request to register diary ----------');
          print(accessToken);

          if (formKey.currentState == null) {
            return null;
          }

          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            return null;
          }

          //   {
          //     "babyId": 1,
          //   "daysAfterBirth": 10,
          //   "userId": 1,
          //   "likeCount": 0,
          //   "date": "2022-10-31",
          //   "sentences": [
          // {"sentence": "지안이가 일어났다."},
          // {"sentence": "지안이가 잠을 잔다."},
          // {"sentence": "지안이가 다시 일어났다."}
          //   ],
          //   "files": [
          // {"fileName": "bbbb.jpg"},
          // {"fileName": "cccc.png"}
          //   ]
          // }

          final response = await dio.post(
            'http://$ip/api/v1/diaries',
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
            }),
            data: {
              "babyId": name,
              "dayAfterBirth": daysAfterBirth,
              "userId": 1,
              "likeCount": 0,
              "date": DateFormat('yyyy-MM-dd').format(diaryDate!).toString(),
              "sentences": [],
              "files": [],
            },
          );

          if (response.statusCode != 201) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: '등록 실패',
                    content: '등록에 실패하였습니다. 잠시 후에 다시 시도해주세요.',
                    buttonText: '확인',
                  );
                });
          }

          print('preSignedUrl ${response.data}');
          String preSignedUrl = response.data['preSignedUrl'];

          print('filePath');
          print(pickedFilePath);
          File file = File(pickedFilePath!);

          var fileExt = file.path.split('.').last == 'jpg'
              ? 'jpeg'
              : file.path.split('.').last;
          await dio.put(preSignedUrl,
              data: file.openRead(),
              options: Options(
                headers: {
                  Headers.contentLengthHeader: file.lengthSync(),
                },
                contentType: 'image/$fileExt',
              ));

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DiaryScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: const Text(
          "등록 하기",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  AppBar diaryAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "기록을 남겨보아요",
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  Expanded datePickerButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50.0,
        child: OutlinedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((value) {
              setState(() {
                diaryDate = value;
                print(diaryDate);

                calculateDaysAfterBirth(diaryDate!);
              });
            });
          },
          child: Text(
            DateFormat('yyyy-MM-dd').format(diaryDate!).toString(),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
      ),
      child: Center(
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
