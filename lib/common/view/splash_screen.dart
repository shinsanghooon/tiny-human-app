import 'package:flutter/material.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // initState에서는 async가 안되기 때문에 함수로 분리한다.
    checkToken();
  }

  void checkToken() async {
    final accessToken =  await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken =  await storage.read(key: REFRESH_TOKEN_KEY);

    print('splash $accessToken');

    if (refreshToken == null || accessToken == null) {
      print('1 splash');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      print('2 splash');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tiny Human",
              style: TextStyle(
                fontSize: 42.0,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
