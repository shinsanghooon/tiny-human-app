import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class ImageContainer extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final bool selected;

  const ImageContainer(
      {required this.url, required this.width, required this.height, this.selected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return selected
        ? checkContainer(
            _sizedContainer(
              _cachedNetworkImage(),
            ),
          )
        : _sizedContainer(
            _cachedNetworkImage(),
          );
  }

  CachedNetworkImage _cachedNetworkImage() {
    return CachedNetworkImage(
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
      errorWidget: (context, url, error) {
        return CircularProgressIndicator(color: PRIMARY_COLOR, strokeWidth: 6.0);
      },
    );
  }

  Widget _sizedContainer(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(child: child),
      ),
    );
  }

  Widget checkContainer(Widget sizedContainer) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        sizedContainer,
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FittedBox(
            child: const Icon(
              Icons.check_circle,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
