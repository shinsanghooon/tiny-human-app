import 'package:flutter/material.dart';

class BabyRegisterImage extends StatefulWidget {
  final ImageProvider selectedProfileImage;

  const BabyRegisterImage({
    required this.selectedProfileImage,
    super.key,
  });

  @override
  State<BabyRegisterImage> createState() => _BabyRegisterImageState();
}

class _BabyRegisterImageState extends State<BabyRegisterImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: MediaQuery.of(context).size.width / 1.3,
        width: MediaQuery.of(context).size.width / 1.3,
        decoration: BoxDecoration(
          image: DecorationImage(image: widget.selectedProfileImage, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
