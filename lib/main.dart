import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/view/splash_screen.dart';
import 'package:tiny_human_app/user/view/login_screen.dart';

import 'album/view/album_screen.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen(),
      )
    );
  }
}
