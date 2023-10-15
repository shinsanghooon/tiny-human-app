import 'package:flutter/material.dart';

class GradientBorderCircleAvatar extends StatelessWidget {
  const GradientBorderCircleAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 1.5,
      width: MediaQuery.of(context).size.width / 1.5,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xffff5841),
            Color(0xffffffff),
            Color(0xffff5841),
          ],
        ),
        borderRadius: BorderRadius.circular(500),
      ),
      child: CircleAvatar(
        radius: 250,
        backgroundImage: NetworkImage(
          "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&h=500&q=80",
        ),
      ),
    );
  }
}
