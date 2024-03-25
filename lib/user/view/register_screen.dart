import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/component/alert_dialog.dart';
import 'package:tiny_human_app/common/component/text_component.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey();
  final dio = Dio();

  String? email;
  String? password;
  String? confirmedPassword;
  String? username;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ScreenTitle(title: "회원가입을 진행합니다."),
                const SizedBox(height: 20.0),
                const ScreenSubTitle(subTitle: "이메일, 패스워드, 이름을 입력하여 회원가입을 진행해주세요."),
                const SizedBox(
                  height: 20.0,
                ),

                // input 필드를 동시에 관리한다.
                Form(
                  key: formKey, // form 아래 있는 모든 필드가 어떻게 동작할지 컨트롤을 해주는 역할
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextFormField(
                        keyName: 'email',
                        onSaved: (String? value) {
                          email = value!;
                        },
                        hintText: "이메일을 입력해주세요.",
                        initialValue: email ?? '',
                      ),
                      const SizedBox(height: 14.0),
                      CustomTextFormField(
                        keyName: 'name',
                        onSaved: (String? value) {
                          username = value!;
                        },
                        hintText: "이름을 입력해주세요.",
                        initialValue: username ?? '',
                      ),
                      const SizedBox(height: 14.0),
                      CustomTextFormField(
                        keyName: 'password',
                        onSaved: (String? value) {
                          password = value!;
                        },
                        obscureText: true,
                        hintText: "비밀번호를 입력해주세요.",
                        initialValue: password ?? '',
                      ),
                      const SizedBox(height: 14.0),
                      CustomTextFormField(
                        keyName: 'confirmedPassword',
                        onSaved: (String? value) {
                          confirmedPassword = value!;
                        },
                        obscureText: true,
                        hintText: "비밀번호를 다시 한 번 입력해주세요.",
                        initialValue: confirmedPassword ?? '',
                      ),
                      const SizedBox(height: 14.0),
                      registerActionButton(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox registerActionButton(BuildContext context) {
    return SizedBox(
      height: 46.0,
      child: ElevatedButton(
        onPressed: () async {
          // formkey를 사용해서 텍스트 필드 검증
          if (formKey.currentState == null) {
            // formKey는 생성을 했는데, Form 위젯과 결합을 안했을때
            return null;
          }

          // form을 쓸 때 동일하게 하는 패턴
          // Form 아래 TextFormField의 validator가 모두 실행됨
          if (formKey.currentState!.validate()) {
            // save를 해주면 TextFormField의 onSaved 함수가 호출된다.
            formKey.currentState!.save();
          } else {
            // 어떤 필드가 문제가 있는 경우.
            return null;
          }

          if (password != confirmedPassword) {
            // 비밀번호 확인을 한다.
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: '확인 필요',
                    content: '비밀번호와 확인 비밀번호가 다릅니다. 다시 한 번 확인해주세요.',
                    buttonText: '확인',
                  );
                });
          } else {
            // 서버에 요청을 보낸다.
            final response = await dio.post(
              '$ip/api/v1/users',
              data: {
                "name": username,
                "email": email,
                "password": password,
              },
            );

            if (response.statusCode != 201) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                      title: '가입 실패',
                      content: '가입이 실패하였습니다. 잠시 후에 다시 시도해주세요.',
                      buttonText: '확인',
                    );
                  });
            }

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
    );
  }
}
