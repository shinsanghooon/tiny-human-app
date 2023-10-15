import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800));
  }
}

class ScreenSubTitle extends StatelessWidget {
  final String subTitle;

  const ScreenSubTitle({required this.subTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(subTitle,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400));
  }
}
