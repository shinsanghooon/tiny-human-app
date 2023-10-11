import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:dio/dio.dart';
import 'package:tiny_human_app/user/component/text_component.dart';
import 'package:tiny_human_app/user/view/register_screen.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/constant/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final emulatorIp = '10.0.2.2.:8080';
    final simulatorIp = '127.0.0.1:8080';

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
                const UserScreenTitle(title: "환영합니다."),
                const SizedBox(
                  height: 20.0,
                ),
                const UserScreenSubTitle(subTitle: "이메일과 비밀번호를 입력해서 로그인해주세요.\n오늘도 타이니 휴먼 한 페이지를 남겨보아요!"),
                const SizedBox(
                  height: 20.0,
                ),
                CustomTextFormField(
                  onChanged: (String value) {
                    email = value;
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
                    // final rawString = '${username}:${password}';
                    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    // String token = stringToBase64.encode(rawString);

                    final response = await dio.post(
                      'http://$ip/api/v1/auth/login',
                      data: {
                        "email": email,
                        "password": password,
                      }
                    );
                    print('login');
                    print(response.data);
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

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RegisterScreen())
                    );
                        
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
