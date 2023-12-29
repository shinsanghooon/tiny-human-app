import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final AppBar? appBar;
  final bool? extendBodyBehindAppBar;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.appBar,
    this.extendBodyBehindAppBar,
    this.title,
    this.bottomNavigationBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: appBar,
      body: child,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
