import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';

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
        model.pictures.first,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      ),
      detail: model.sentences.first,
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 10,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(8.0), child: image),
            const SizedBox(width: 12.0),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일'),
                        Text('+${afterBirthDay} 일'),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      detail,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13.0,
                          color: BODY_TEXT_COLOR,
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
