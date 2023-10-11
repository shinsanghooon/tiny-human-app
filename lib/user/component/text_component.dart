import 'package:flutter/material.dart';

class UserScreenTitle extends StatelessWidget {
  final String title;

  const UserScreenTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800));
  }
}

class UserScreenSubTitle extends StatelessWidget {
  final String subTitle;

  const UserScreenSubTitle({required this.subTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(subTitle,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400));
  }
}
