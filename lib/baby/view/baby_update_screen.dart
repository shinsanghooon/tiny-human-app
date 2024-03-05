import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:tiny_human_app/baby/model/baby_model.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/common/utils/s3_url_generator.dart';

import '../../common/component/alert_dialog.dart';
import '../../common/component/custom_long_text_form_field.dart';
import '../../common/component/custom_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import '../provider/baby_provider.dart';

class BabyUpdateScreen extends ConsumerStatefulWidget {
  final BabyModel model;

  const BabyUpdateScreen({
    required this.model,
    super.key,
  });

  @override
  ConsumerState<BabyUpdateScreen> createState() => _BabyRegisterScreenState();
}

class _BabyRegisterScreenState extends ConsumerState<BabyUpdateScreen> {
  final dio = Dio();
  final GlobalKey<FormState> formKey = GlobalKey();
  String? accessToken;

  // profile image
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  XFile? pickedFile;
  ImageProvider? profileImage;
  String? pickedFilePath;

  // gender
  List<String> genderList = ['남자 아기', '여자 아기'];
  List<bool> _selectedGender = <bool>[true, false];

  String? name;
  String? nickname;
  DateTime? dayOfBirth;
  int? timeOfBirth;
  String? gender;
  String? fileName;
  String? relation;
  String? description;

  // 변경전 필드 값
  // String? baseName;
  // String? baseNickName;
  // DateTime? baseDayOfBirth;
  // int? baseTimeOfBirth;
  // String? baseGender;
  // String? baseDescription;
  String? baseImageUrl;

  @override
  void initState() {
    super.initState();
    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();

    // base value
    name = widget.model.name;
    nickname = widget.model.nickName;
    gender = widget.model.gender == 'MALE' ? genderList[0] : genderList[1];
    _selectedGender = genderList.map((e) => e == gender).toList();
    timeOfBirth = widget.model.timeOfBirth;
    dayOfBirth = DateConvertor.stringToDateTime(widget.model.dayOfBirth);
    description = widget.model.description;
    baseImageUrl = S3UrlGenerator.getThumbnailUrlWith1000wh(widget.model.profileImgKeyName);
  }

  void checkToken() async {
    accessToken = (await storage.read(key: ACCESS_TOKEN_KEY))!;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: _babyAppBar(context),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  profileMainImage(),
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
                            initialValue: description ?? "",
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        _updateBabyActionButton(context),
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

  GestureDetector profileMainImage() {
    return (baseImageUrl == null)
        ? GestureDetector(
            onTap: () async {
              final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  pickedFilePath = pickedFile.path;
                  profileImage = Image.file(File(pickedFile.path)).image;
                  fileName = pickedFile.name;
                });
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 1.2,
              width: MediaQuery.of(context).size.width / 1.2,
              color: Colors.deepOrange.shade500,
              child: _uploadPhotoLabel(),
            ),
          )
        : GestureDetector(
            onTap: () async {
              final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  pickedFilePath = pickedFile.path;
                  profileImage = Image.file(File(pickedFile.path)).image;
                  fileName = pickedFile.name;
                });
              }
            },
            child: pickedFilePath == null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image.network(
                      baseImageUrl!,
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.width / 1.3,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image.asset(
                      pickedFilePath!,
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.width / 1.3,
                      fit: BoxFit.cover,
                    ),
                  ),
          );
  }

  Widget _uploadPhotoLabel() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.photo_outlined,
          size: 100.0,
        ),
        Text(
          "사진을 업로드 해주세요.",
          style: TextStyle(
            fontSize: 20.0,
          ),
        )
      ],
    );
  }

  SizedBox _updateBabyActionButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      child: ElevatedButton(
        onPressed: () async {
          // 서버에 요청을 보낸다.
          print('Request to register baby');
          print(accessToken);

          if (formKey.currentState == null) {
            return null;
          }

          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            return null;
          }

          // 수정된 필드 확인하기
          // 사진, 이름, 태명, 성별, 날짜, 시간, 설명

          int babyId = 1;

          try {
            final response = await ref.read(babyProvider.notifier).updateBaby(
              babyId: babyId,
              body: {
                "name": name,
                "gender": gender == '남자 아기' ? 'MALE' : 'FEMALE',
                "dayOfBirth": DateFormat('yyyy-MM-dd').format(dayOfBirth!).toString(),
                "timeOfBirth": timeOfBirth,
                "nickName": nickname,
                "keyName": fileName,
                "description": description,
                "relation": 'FATHER',
              },
            );
          } catch (e) {
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const CustomAlertDialog(
                    title: '수정 실패',
                    content: '수정에 실패하였습니다. 잠시 후에 다시 시도해주세요.',
                    buttonText: '확인',
                  );
                },
              );
            }
          }

          // 이미지 업로드
          if (fileName != null) {
            final response =
                await ref.read(babyProvider.notifier).updateBabyProfile(babyId: babyId, body: {"fileName": fileName});

            String preSignedUrl = response.preSignedUrl;
            File file = File(pickedFilePath!);

            String? mimeType = lookupMimeType(file.path);

            await dio.put(preSignedUrl,
                data: file.openRead(),
                options: Options(
                  headers: {
                    Headers.contentLengthHeader: file.lengthSync(),
                  },
                  contentType: mimeType,
                ));
          }

          ref.read(babyProvider.notifier).getMyBabies();

          if (mounted) {
            print('수정하기 버튼 클릭!');
            // context.goNamed(BabyScreen.routeName);
            context.pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: const Text(
          "수정 하기",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  AppBar _babyAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "아기 정보를 수정해주세요",
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
        onPressed: () {
          context.pop();
        },
      ),
      elevation: 0.0,
    );
  }

  Widget genderSelectionButton() {
    // https://stackoverflow.com/questions/60456821/expand-toggle-buttons-to-parent-container-width
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ToggleButtons(
            constraints: BoxConstraints.expand(width: (constraints.maxWidth - 4) / 2),
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
              return toggleButtonByGender(gender);
            }).toList(),
          );
        },
      ),
    );
  }

  Widget toggleButtonByGender(String gender) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gender == '여자 아기'
              ? const Icon(
                  Icons.female_outlined,
                  // color: Colors.pink,
                  size: 20.0,
                )
              : const Icon(
                  Icons.male_outlined,
                  // color: Colors.blueAccent,
                  size: 20.0,
                ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            gender,
            style: gender == '여자 아기'
                ? const TextStyle(
                    fontSize: 16.0,
                    // color: Colors.pink,
                    fontWeight: FontWeight.w600,
                  )
                : const TextStyle(
                    fontSize: 16.0,
                    // color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
          )
        ],
      ),
    );
  }

  Widget datePickerButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 46.0,
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
              });
            });
          },
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: Colors.black54,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(dayOfBirth!).toString(),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded timePickerButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50.0,
        child: OutlinedButton(
          onPressed: () {
            _showTimeDialog(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.watch_later_outlined,
                color: Colors.black54,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                timeOfBirth != null ? '${timeOfBirth.toString().split(" ")[0]}시' : '태어난 시간',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ],
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
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownMenu<int>(
                menuHeight: 300,
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
            ],
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
