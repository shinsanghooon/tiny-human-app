import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final AppBar? appBar;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: appBar,
        body: child
    );
  }
}
