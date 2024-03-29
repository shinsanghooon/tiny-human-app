import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/component/image_container.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';

import '../../common/utils/s3_url_generator.dart';

class DiaryCard extends StatelessWidget {
  final int id;
  final String detail;
  final Widget? image;
  final DateTime createdAt;
  final int afterBirthDay;

  const DiaryCard(
      {required this.id,
      required this.detail,
      required this.createdAt,
      required this.afterBirthDay,
      this.image,
      super.key});

  factory DiaryCard.fromDiaryModel({
    required DiaryResponseModel model,
  }) {
    return DiaryCard(
      id: model.id,
      image: ImageContainer(
        url: S3UrlGenerator.getThumbnailUrlWith300wh(model.pictures.first.keyName),
        width: 120,
        height: 120,
      ),
      detail: model.sentences.first.sentence,
      createdAt: model.date,
      afterBirthDay: model.daysAfterBirth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8.0), child: image!),
            const SizedBox(width: 18.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          color: PRIMARY_COLOR,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.5),
                          child: Text(
                            '+$afterBirthDay일',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    detail,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16.0, color: BODY_TEXT_COLOR, height: 1.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}
