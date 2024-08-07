// utils.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastWithMessage(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.black.withOpacity(0.6),
    textColor: Colors.white,
  );
}
