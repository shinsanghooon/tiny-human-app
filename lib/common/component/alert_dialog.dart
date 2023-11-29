import 'package:flutter/material.dart';

import '../constant/colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;

  const CustomAlertDialog({
    required this.title,
    required this.content,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: registerAlertTitle(title),
        content: registerAlertContent(content),
        actions: [
          registerActionButton(
            context,
            buttonText
          ),
        ]);
  }

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
      ),
    );
  }

  Padding registerAlertContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        content,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget registerAlertTitle(String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
