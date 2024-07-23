import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

class SplashScreen extends ConsumerWidget {
  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/images/logo.png',
              height: 140,
              width: 140,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              APP_TITLE,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w900,
                color: PRIMARY_COLOR,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            CircularProgressIndicator(
              color: PRIMARY_COLOR,
              strokeWidth: 6.0,
            )
          ],
        ),
      ),
    );
  }
}
