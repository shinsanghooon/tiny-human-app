import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/utils/validator.dart';

class CustomTextFormField extends StatelessWidget {
  final String keyName;
  final bool obscureText;
  final bool autofocus;
  final FormFieldSetter<String> onSaved;
  final String? hintText;
  final String? errorText;
  final String initialValue;

  const CustomTextFormField({
    required this.keyName,
    this.obscureText = false,
    this.autofocus = false,
    required this.onSaved,
    this.hintText,
    this.errorText,
    required this.initialValue,
    super.key,
  });

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
      onSaved: onSaved,
      validator: (value) {
              if (value == null || value.isEmpty) {
                return '필수 입력값입니다.';
              }

              if(keyName == 'email' && !isValidEmail(value)) {
                print(value);
                return '올바른 이메일 주소를 입력해주세요';
              }

              return null;
            },
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
