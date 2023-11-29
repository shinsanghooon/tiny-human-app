import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';

import '../../common/constant/data.dart';

class DiaryCard extends StatelessWidget {
  final int id;
  final String detail;
  final Image? image;
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
      image: Image.network(
        '$S3_BASE_URL${model.pictures.first.keyName}',
        width: 160,
        height: 160,
        fit: BoxFit.cover,
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
            ClipRRect(borderRadius: BorderRadius.circular(8.0), child: image),
            const SizedBox(width: 18.0),
            Expanded(
              child: Container(
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
                        Text('+$afterBirthDay일',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            )),
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
                          fontSize: 16.0,
                          color: BODY_TEXT_COLOR,
                          height: 1.5,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}
