import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeadingLogoIcon extends StatelessWidget {
  const LeadingLogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          'asset/images/logo.png',
        ),
      ),
    );
  }
}
