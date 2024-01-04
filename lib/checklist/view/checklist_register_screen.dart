import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

class ChecklistRegisterScreen extends StatelessWidget {
  const ChecklistRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text("Register Checklist"),
      ),
    );
  }
}
