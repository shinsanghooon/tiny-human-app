import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const ImageContainer(
      {required this.url,
      required this.width,
      required this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    return _sizedContainer(
      CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 100),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      ),
    );
  }

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(child: child),
    );
  }
}
