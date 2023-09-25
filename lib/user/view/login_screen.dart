import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:dio/dio.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/constant/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final emulatorIp = '10.0.2.2.:3000';
    final simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS == true ? simulatorIp : emulatorIp;

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 20.0,
                ),
                const _subTitle(),
                const SizedBox(
                  height: 20.0,
                ),
                CustomTextFormField(
                  onChanged: (String value) {
                    username = value;
                  },
                  hintText: "이메일을 입력해주세요.",
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                  hintText: "비밀번호를 입력해주세요.",
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final rawString = '${username}:${password}';
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String token = stringToBase64.encode(rawString);

                    final response = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {'authorization': 'Basic $token'},
                      ),
                    );
                    final accessToken = response.data['accessToken'];
                    final refreshToken = response.data['refreshToken'];

                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: accessToken);
                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refreshToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AlbumScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: const Text(
                    "로그인",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    const refreshToken =
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY5NTYzMjgwNSwiZXhwIjoxNjk1NzE5MjA1fQ.NB0sjH2QRSXP8AOY5KlkIa50S7MH5j3m1-m3r7pU-OQ';
                    final response = await dio.post('http://$ip/auth/token',
                        options: Options(headers: {
                          'authorization': 'Bearer $refreshToken'
                        }));

                    print(response.data);
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
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("환영합니다.",
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800));
  }
}

class _subTitle extends StatelessWidget {
  const _subTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("이메일과 비밀번호를 입력해서 로그인해주세요.\n오늘도 타이니 휴먼 한 페이지를 남겨보아요!",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400));
  }
}
