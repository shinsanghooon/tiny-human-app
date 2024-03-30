import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

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
      borderRadius: BorderRadius.circular(24.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 1.4,
        width: MediaQuery.of(context).size.width / 1.4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 이미지를 배경으로 설정
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.selectedProfileImage,
                  fit: BoxFit.scaleDown,
                  scale: 1.0,
                ),
                color: PRIMARY_COLOR,
              ),
            ), // 텍스트를 이미지 위에 중앙 아래에 위치시킴
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  "사진을 선택해주세요.",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
