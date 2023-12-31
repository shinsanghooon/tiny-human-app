import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/component/text_component.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/user/model/user_model.dart';
import 'package:tiny_human_app/user/provider/user_me_provider.dart';
import 'package:tiny_human_app/user/view/register_screen.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/constant/data.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ScreenTitle(title: "환영합니다."),
                const SizedBox(
                  height: 20.0,
                ),
                const ScreenSubTitle(
                    subTitle:
                        "이메일과 비밀번호를 입력해서 로그인해주세요.\n오늘도 ${APP_TITLE}에 하루를 남겨보세요!"),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: formKey,
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
                      const SizedBox(height: 16.0),
                      CustomTextFormField(
                        keyName: 'password',
                        onSaved: (String? value) {
                          password = value!;
                        },
                        obscureText: true,
                        hintText: "비밀번호를 입력해주세요.",
                        initialValue: password ?? '',
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: state is UserModelLoading
                            ? null
                            : () async {
                                // final rawString = '${username}:${password}';
                                // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                                // String token = stringToBase64.encode(rawString);

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

                                ref
                                    .read(userMeProvider.notifier)
                                    .login(email: email, password: password);

                                // final response = await dio.post(
                                //   'http://$ip/api/v1/auth/login',
                                //   data: {
                                //     "email": email,
                                //     "password": password,
                                //   },
                                // );
                                // print('login');
                                // print(response.data);
                                // final accessToken = response.data['accessToken'];
                                // final refreshToken = response.data['refreshToken'];
                                //
                                // await storage.write(
                                //     key: ACCESS_TOKEN_KEY, value: accessToken);
                                // await storage.write(
                                //     key: REFRESH_TOKEN_KEY, value: refreshToken);
                                //
                                // Navigator.of(context).pushAndRemoveUntil(
                                //   MaterialPageRoute(
                                //     builder: (_) => RootScreen(),
                                //   ),
                                //   (route) => false,
                                // );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                        ),
                        child: const Text(
                          "로그인",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const RegisterScreen()));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: PRIMARY_COLOR,
                        ),
                        child: const Text(
                          "회원 가입",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
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
    );
  }
}
