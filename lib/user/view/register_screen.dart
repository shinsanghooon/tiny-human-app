import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tiny_human_app/user/component/text_component.dart';
import 'package:tiny_human_app/user/view/login_screen.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String confirmedPassword = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const UserScreenTitle(title: "회원가입을 진행합니다."),
                  const SizedBox(height: 20.0),
                  const UserScreenSubTitle(
                      subTitle: "이메일, 패스워드, 이름을 입력하여 회원가입을 진행해주세요."),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                    onChanged: (String value) {
                      email = value;
                    },
                    hintText: "이메일을 입력해주세요.",
                  ),
                  const SizedBox(height: 14.0),
                  CustomTextFormField(
                    onChanged: (String value) {
                      username = value;
                    },
                    hintText: "이름을 입력해주세요.",
                  ),
                  const SizedBox(height: 14.0),
                  CustomTextFormField(
                    onChanged: (String value) {
                      password = value;
                    },
                    obscureText: true,
                    hintText: "비밀번호를 입력해주세요.",
                  ),
                  const SizedBox(height: 14.0),
                  CustomTextFormField(
                    onChanged: (String value) {
                      confirmedPassword = value;
                    },
                    obscureText: true,
                    hintText: "비밀번호를 다시 한 번 입력해주세요.",
                  ),
                  const SizedBox(height: 14.0),
                  SizedBox(
                    height: 46.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (password != confirmedPassword) {
                          // 비밀번호 확인을 한다.
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    title: registerAlertTitle(),
                                    content: registerAlertContent(),
                                    actions: [
                                      registerActionButton(context),
                                    ]);
                              });
                        } else {
                          // 서버에 요청을 보낸다.

                          final response = await dio.post(
                            'http://$ip/api/v1/users',
                            data: {
                              "name": username,
                              "email": email,
                              "password": password,
                            },
                          );
                          print(response);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: const Text(
                        "가입 하기",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  TextButton registerActionButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Center(
        child: Text(
          "확인",
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

  Padding registerAlertContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        "비밀번호가 일치하지 않습니다. 확인해주세요.",
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget registerAlertTitle() {
    return Column(
      children: [
        Text(
          "확인 필요",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
