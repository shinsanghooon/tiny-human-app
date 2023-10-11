import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final String? errorText;
  final bool requiredValue;

  const CustomTextFormField(
      {this.obscureText = false,
      this.autofocus = false,
      required this.onChanged,
      this.hintText,
      this.errorText,
      this.requiredValue = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      validator: requiredValue
          ? (value) {
              if (value == null || value.isEmpty) {
                return '필수 값입니다.';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20.0),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 16.0,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,

        // 기본으로 세팅한 보더를 넣어준다.
        enabledBorder: baseBorder,

        focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(color: PRIMARY_COLOR)),
      ),
    );
  }
}
