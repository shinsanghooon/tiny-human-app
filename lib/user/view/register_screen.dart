import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tiny_human_app/user/view/login_screen.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/component/loading_spinner.dart';
import '../../common/component/show_toast.dart';
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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40.0),
                const Text(
                  'Join us!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),

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
                      const SizedBox(height: 48.0),
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
            setState(() {
              isLoading = true;
            });
            return null;
          }

          // form을 쓸 때 동일하게 하는 패턴
          // Form 아래 TextFormField의 validator가 모두 실행됨
          if (formKey.currentState!.validate()) {
            // save를 해주면 TextFormField의 onSaved 함수가 호출된다.
            formKey.currentState!.save();
          } else {
            // 어떤 필드가 문제가 있는 경우.
            setState(() {
              isLoading = true;
            });
            return null;
          }

          if (password != confirmedPassword) {
            showToastWithMessage('입력하신 두 개의 비밀번호가 일치하지 않습니다. 비밀번호를 확인해주세요.');
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

            if (response.statusCode == 201) {
              showToastWithMessage("회원가입이 완료 되었습니다. 로그인을 해주세요.");
            } else {
              showToastWithMessage("가입이 실패하였습니다. 잠시 후에 다시 시도해주세요.");
            }

            setState(() {
              isLoading = true;
            });

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: isLoading
            ? const LoadingSpinner()
            : const Text(
          "가입 하기",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
