import 'package:flutter/material.dart';

import '../../common/layout/default_layout.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text("Settings"),
      ),
    );
  }
}
