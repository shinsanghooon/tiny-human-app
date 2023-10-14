import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text("Diary"),
      ),
    );
  }
}
