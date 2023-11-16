import 'package:flutter/material.dart';

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
    return IntrinsicHeight(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl == "" ? SAMPLE_BABY_IMAGE_URL : imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.width / 1,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, bottom: 20.0,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  birth,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
