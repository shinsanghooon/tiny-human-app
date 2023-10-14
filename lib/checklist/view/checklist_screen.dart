import 'package:flutter/material.dart';

import '../../common/layout/default_layout.dart';

class CheckListScreen extends StatelessWidget {
  const CheckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text("Check List"),
      ),
    );
  }
}
