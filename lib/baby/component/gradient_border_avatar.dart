import 'package:flutter/material.dart';

class GradientBorderCircleAvatar extends StatefulWidget {
  final ImageProvider selectedProfileImage;

  const GradientBorderCircleAvatar({
    required this.selectedProfileImage,
    super.key,
  });

  @override
  State<GradientBorderCircleAvatar> createState() =>
      _GradientBorderCircleAvatarState();
}

class _GradientBorderCircleAvatarState
    extends State<GradientBorderCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: MediaQuery.of(context).size.width / 1.2,
    //   width: MediaQuery.of(context).size.width / 1.2,
    //   padding: const EdgeInsets.all(10),
    //   decoration: BoxDecoration(
    //     gradient: const LinearGradient(
    //       begin: Alignment.bottomRight,
    //       end: Alignment.topLeft,
    //       colors: [
    //         Color(0xffff5841),
    //         Color(0xffffffff),
    //         Color(0xffff5841),
    //       ],
    //     ),
    //     borderRadius: BorderRadius.circular(200.0),
    //   ),
    //   child: CircleAvatar(
    //     radius: 0.0,
    //     backgroundImage: widget.selectedProfileImage,
    //   ),
    // );
    return Container(
      height: MediaQuery.of(context).size.width / 1.3,
      width: MediaQuery.of(context).size.width / 1.3,
      child: CircleAvatar(
        radius: 0.0,
        backgroundImage: widget.selectedProfileImage,
      ),
    );
  }
}
