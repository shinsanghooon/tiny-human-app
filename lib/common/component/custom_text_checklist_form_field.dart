import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class CustomTextChecklistFormField extends StatelessWidget {
  final String keyName;
  final bool obscureText;
  final bool autofocus;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? errorText;
  final String initialValue;

  const CustomTextChecklistFormField({
    required this.keyName,
    this.obscureText = false,
    this.autofocus = false,
    required this.onSaved,
    this.onChanged,
    this.hintText,
    this.errorText,
    required this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.transparent,
    ));

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      onSaved: onSaved,
      initialValue: initialValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 입력값입니다.';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        icon: const Icon(
          Icons.check,
          color: PRIMARY_COLOR,
          size: 20.0,
        ),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 20.0,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
            borderSide:
                baseBorder.borderSide.copyWith(color: Colors.transparent)),
      ),
    );
  }
}
