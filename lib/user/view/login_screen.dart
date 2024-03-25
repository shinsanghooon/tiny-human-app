import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
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
                const ScreenSubTitle(subTitle: "이메일과 비밀번호를 입력해서 로그인해주세요.\n오늘도 ${APP_TITLE}에 하루를 남겨보세요!"),
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

                                ref.read(userMeProvider.notifier).login(email: email, password: password);
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
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
                      ),
                      ElevatedButton(
                        onPressed: () => onGoogleLoginPress(context),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                        child: const Text("구글 로그인",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      ElevatedButton(
                        onPressed: () => onKakaoLoginPress(context),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                        child: const Text("카카오 로그인",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            )),
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

  onGoogleLoginPress(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
    ]);

    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await account?.authentication;
      final accessToken = googleAuth?.accessToken;
      final idToken = googleAuth?.idToken;

      final credential = GoogleAuthProvider.credential(accessToken: accessToken, idToken: idToken);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final name = userCredential.user?.displayName;
      final photoURL = userCredential.user?.photoURL;
      final email = userCredential.user?.email;

      ref.read(userMeProvider.notifier).googleLogin(
            email: email!,
            accessToken: accessToken!,
            name: name!,
            photoURL: photoURL!,
          );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패')),
      );
    }
  }

  onKakaoLoginPress(BuildContext context) async {
    User user;
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

    user = await UserApi.instance.me();
    print(user.kakaoAccount);

    ref.read(userMeProvider.notifier).kakaoLogin(
          email: '${user.id}@kakao.com',
          accessToken: user.id.toString(),
          name: user.kakaoAccount!.profile!.nickname!,
          photoURL: user.kakaoAccount!.profile!.profileImageUrl!,
        );
  }
}
