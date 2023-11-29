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
      child: Padding(
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
              height: 12.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl == "" ? SAMPLE_BABY_IMAGE_URL : imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / 1.7,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
            ),
            const SizedBox(
              height: 12.0,
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
            const SizedBox(height: 8.0,),
            Divider(color: Colors.grey.shade300, thickness: 1.0,),
          ],
        ),
      ),
    );
  }
}
