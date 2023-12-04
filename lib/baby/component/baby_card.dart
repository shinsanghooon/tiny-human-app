import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/component/image_container.dart';

import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';

class BabyCard extends StatelessWidget {
  final String name;
  final String gender;
  final String birth;
  final String description;
  final String imageUrl;

  const BabyCard(
      {required this.name,
      required this.gender,
      required this.birth,
      this.description = "",
      this.imageUrl = "",
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: ImageContainer(
              url: imageUrl == "" ? SAMPLE_BABY_IMAGE_URL : imageUrl,
              width: MediaQuery.of(context).size.width / 1.7,
              height: MediaQuery.of(context).size.width / 1.7,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Icon(
            Icons.horizontal_rule_outlined,
            color: PRIMARY_COLOR.withOpacity(0.7),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            birth,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            gender,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
