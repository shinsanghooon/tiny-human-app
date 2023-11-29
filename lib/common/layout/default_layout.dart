import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final AppBar? appBar;
  final bool? extendBodyBehindAppBar;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.appBar,
    this.extendBodyBehindAppBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: appBar,
        body: child,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
    );
  }
}
