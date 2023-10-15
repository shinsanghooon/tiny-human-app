import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiny_human_app/baby/component/gradient_border_avatar.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/component/text_component.dart';
import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';

class BabyRegisterScreen extends StatefulWidget {
  const BabyRegisterScreen({super.key});

  @override
  State<BabyRegisterScreen> createState() => _BabyRegisterScreenState();
}

class _BabyRegisterScreenState extends State<BabyRegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  List<int> times = List.generate(24, (index) => index);

  List<String> genderList = ['남자 아기', '여자 아기'];
  final List<bool> _selectedGender = <bool>[true, false];

  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  String? name;
  String? nickname;
  DateTime? dayOfBirth;
  int? timeOfBirth;
  String? gender;
  String? relation;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        title: const Text(
          "아기를 등록해주세요",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () async {
                        final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                        if(pickedFile != null) {
                          setState(() {
                            _image = XFile(pickedFile.path);
                          });
                        }
                      },
                      child: GradientBorderCircleAvatar()),
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
                        )
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

  ToggleButtons genderSelectionButton() {
    return ToggleButtons(
      constraints: const BoxConstraints(
        minHeight: 50.0,
        minWidth: 170.0,
      ),
      children: genderList.map((gender) {
        return Text(
          gender,
          style: TextStyle(fontWeight: FontWeight.w600),
        );
      }).toList(),
      onPressed: (int index) {
        setState(() {
          gender = genderList[index];
          for (int i = 0; i < _selectedGender.length; i++) {
            _selectedGender[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      selectedBorderColor: PRIMARY_COLOR,
      selectedColor: Colors.white,
      fillColor: PRIMARY_COLOR,
      color: PRIMARY_COLOR,
      isSelected: _selectedGender,
    );
  }

  Expanded datePickerButton(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50.0,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: PRIMARY_COLOR,
          ),
          onPressed: () {
            showDatePicker(
              context: context,
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
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: PRIMARY_COLOR,
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
          style: OutlinedButton.styleFrom(
              foregroundColor: PRIMARY_COLOR,
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          onPressed: () {
            _showTimeDialog(context);
          },
          child: Text(
            timeOfBirth != null
                ? timeOfBirth.toString().split(" ")[0] + '시'
                : "태어난 시간",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
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
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
      ),
    );
  }
}
