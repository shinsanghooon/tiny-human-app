import 'package:flutter/material.dart';

import '../../common/layout/default_layout.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text("Help"),
      ),
    );
  }
}
