import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiny_human_app/baby/component/gradient_border_avatar.dart';
import 'package:tiny_human_app/baby/view/baby_screen.dart';
import 'package:intl/intl.dart';

import '../../common/component/alert_dialog.dart';
import '../../common/component/custom_long_text_form_field.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';

class BabyRegisterScreen extends StatefulWidget {
  const BabyRegisterScreen({super.key});

  @override
  State<BabyRegisterScreen> createState() => _BabyRegisterScreenState();
}

class _BabyRegisterScreenState extends State<BabyRegisterScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();

  // profile image
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  XFile? pickedFile;
  ImageProvider profileImage = const NetworkImage(SAMPLE_BABY_IMAGE_URL);

  // gender
  List<String> genderList = ['남자 아기', '여자 아기'];
  final List<bool> _selectedGender = <bool>[true, false];

  String? name;
  String? nickname;
  DateTime? dayOfBirth;
  int? timeOfBirth;
  String? gender;
  String? fileName;
  String? relation;
  String? description;

  @override
  void initState() {
    super.initState();
    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();
  }

  String accessToken = '';
  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: BabyAppBar(context),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileAvatar(),
                  const SizedBox(height: 20.0),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFormField(
                          keyName: 'name',
                          onSaved: (String? value) {
                            name = value!;
                          },
                          hintText: "이름을 입력해주세요.",
                          initialValue: name ?? '',
                        ),
                        const SizedBox(height: 14.0),
                        CustomTextFormField(
                          keyName: 'nickname',
                          onSaved: (String? value) {
                            nickname = value!;
                          },
                          hintText: "태명을 입력해주세요.",
                          initialValue: nickname ?? '',
                        ),
                        const SizedBox(height: 20.0),
                        genderSelectionButton(),
                        const SizedBox(height: 20.0),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              datePickerButton(context),
                              const SizedBox(width: 12.0),
                              timePickerButton(context),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          height: 250,
                          child: CustomLongTextFormField(
                            keyName: 'description',
                            onSaved: (String? value) {
                              description = value!;
                            },
                            hintText: "아기의 첫 모습이 어땠는지 남겨주세요.",
                            initialValue: description ?? '',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        registerBabyActionButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector ProfileAvatar() {
    return GestureDetector(
                  onTap: () async {
                    final XFile? pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        profileImage =
                            Image.file(File(pickedFile!.path)).image;
                        fileName = pickedFile.name;
                      });
                    }
                  },
                  child: GradientBorderCircleAvatar(
                      selectedProfileImage: profileImage),
                );
  }

  SizedBox registerBabyActionButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      child: ElevatedButton(
        onPressed: () async {
          // 서버에 요청을 보낸다.
          print('Request to register baby');
          print(accessToken);

          if(formKey.currentState == null) {
            return null;
          }

          if(formKey.currentState!.validate()){
            formKey.currentState!.save();
          } else {
            return null;
          }

          final response = await dio.post(
            'http://$ip/api/v1/babies',
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
            }),
            data: {
              "name": name,
              "gender": gender == '남자 아기' ? 'MALE' : 'FEMALE',
              "dayOfBirth": DateFormat('yyyy-MM-dd').format(dayOfBirth!).toString(),
              "timeOfBirth": timeOfBirth,
              "nickName": nickname,
              "fileName": fileName,
              "relation": 'FATHER',
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

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BabyScreen(),
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

  AppBar BabyAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "아기를 등록해주세요",
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

  ToggleButtons genderSelectionButton() {
    return ToggleButtons(
      constraints: const BoxConstraints(
        minHeight: 50.0,
        minWidth: 170.0,
      ),
      onPressed: (int index) {
        setState(() {
          gender = genderList[index];
          for (int i = 0; i < _selectedGender.length; i++) {
            _selectedGender[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      selectedBorderColor: PRIMARY_COLOR,
      selectedColor: Colors.black,
      fillColor: Colors.white,
      color: Colors.grey,
      isSelected: _selectedGender,
      children: genderList.map((gender) {
        return Text(
          gender,
          style: const TextStyle(fontWeight: FontWeight.w600),
        );
      }).toList(),
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
                dayOfBirth = value;
                print(dayOfBirth);
              });
            });
          },
          child: Text(
            dayOfBirth != null ? dayOfBirth.toString().split(" ")[0] : "태어난 날짜",
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Expanded timePickerButton(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50.0,
        child: OutlinedButton(
          onPressed: () {
            _showTimeDialog(context);
          },
          child: Text(
            timeOfBirth != null
                ? '${timeOfBirth.toString().split(" ")[0]}시'
                : "태어난 시간",
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _showTimeDialog(BuildContext context) {
    List<int> times = List.generate(24, (index) => index);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '태어난 시간을 선택해주세요.',
            textAlign: TextAlign.center,
          ),
          content: DropdownMenu<int>(
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 6.0),
            ),
            initialSelection: timeOfBirth ?? times.first,
            onSelected: (int? value) {
              timeOfBirth = value!;
            },
            dropdownMenuEntries: times.map(
              (t) {
                return DropdownMenuEntry(value: t, label: '${t}시');
              },
            ).toList(),
          ),
          actions: [
            registerActionButton(
              context,
              '확인',
            ),
          ],
        );
      },
    ).then((value) {
      // showDialog가 닫힌 후 선택된 항목 처리
      if (value != null) {
        print('선택된 항목: $value');
      }
    });
  }

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        setState(() {
          timeOfBirth = timeOfBirth;
        });
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
