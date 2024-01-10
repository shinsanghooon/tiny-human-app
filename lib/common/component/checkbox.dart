import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onCheckChanged;

  const CustomCheckBox({
    required this.isChecked,
    required this.onCheckChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      fillColor: MaterialStateProperty.all<Color>(Colors.white),
      activeColor: PRIMARY_COLOR,
      side: const BorderSide(color: PRIMARY_COLOR),
      checkColor: PRIMARY_COLOR,
      isError: true,
      tristate: false,
      // - 표시 기능
      value: isChecked,
      onChanged: onCheckChanged,
    );
  }
}
