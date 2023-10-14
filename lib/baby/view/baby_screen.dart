import 'package:flutter/material.dart';

import '../../common/layout/default_layout.dart';

class BabyScreen extends StatelessWidget {
  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Center(
        child: Text("Baby"),
      ),
    );
  }
}
