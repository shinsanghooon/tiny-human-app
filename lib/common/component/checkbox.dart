import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({super.key});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool? isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      fillColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR),
      activeColor: PRIMARY_COLOR,
      side: const BorderSide(color: Colors.transparent),
      isError: true,
      tristate: false,
      // - 표시 기능
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
