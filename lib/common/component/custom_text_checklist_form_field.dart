import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class CustomTextChecklistFormField extends StatefulWidget {
  final String keyName;
  final bool obscureText;
  final bool autofocus;
  final FormFieldSetter<String> onSaved;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final String? errorText;
  final FocusNode? focusNode;
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
    this.focusNode,
    super.key,
  });

  @override
  State<CustomTextChecklistFormField> createState() => _CustomTextChecklistFormFieldState();
}

class _CustomTextChecklistFormFieldState extends State<CustomTextChecklistFormField> {
  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.transparent,
    ));

    print('focusNode ${widget.focusNode}');
    print('------');

    return TextFormField(
      key: GlobalKey<FormState>(debugLabel: widget.keyName),
      focusNode: widget.focusNode,
      cursorColor: PRIMARY_COLOR,
      obscureText: widget.obscureText,
      autofocus: widget.autofocus,
      maxLines: null,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      initialValue: widget.initialValue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '필수 입력값입니다.';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 18.0,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        icon: const Icon(
          Icons.keyboard_arrow_right,
          color: PRIMARY_COLOR,
          size: 18.0,
        ),
        hintText: widget.hintText,
        errorText: widget.errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 18.0,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(borderSide: baseBorder.borderSide.copyWith(color: Colors.transparent)),
      ),
    );
  }
}
