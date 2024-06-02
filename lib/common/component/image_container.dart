import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class ImageContainer extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final bool selected;

  const ImageContainer(
      {required this.url, required this.width, required this.height, this.selected = false, super.key});

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  Key _imageKey = UniqueKey();
  Timer? _retryTimer;

  @override
  Widget build(BuildContext context) {
    return widget.selected
        ? checkContainer(
            _sizedContainer(
              _cachedNetworkImage(),
            ),
          )
        : _sizedContainer(
            _cachedNetworkImage(),
          );
  }

  void _retryLoadingImage() {
    _retryTimer?.cancel(); // 기존 타이머가 있다면 취소
    _retryTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        // 이미지 로드를 재시도하기 위해 key를 변경
        _imageKey = UniqueKey();
      });
    });
  }

  CachedNetworkImage _cachedNetworkImage() {
    return CachedNetworkImage(
      key: _imageKey,
      imageUrl: widget.url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      fadeInDuration: const Duration(milliseconds: 500),
      fadeOutDuration: const Duration(milliseconds: 500),
      errorWidget: (context, url, error) {
        _retryLoadingImage();

        return DottedBorder(
          color: PRIMARY_COLOR.withOpacity(0.7),
          borderType: BorderType.RRect,
          radius: const Radius.circular(8.0),
          strokeWidth: 5.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const SpinKitDoubleBounce(
              color: PRIMARY_COLOR,
              size: 40.0,
              duration: Duration(milliseconds: 2000),
            ),
          ),
        );
      },
    );
  }

  Widget _sizedContainer(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
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
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: FittedBox(
            child: Icon(
              Icons.check_circle,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
      ],
    );
  }
}
