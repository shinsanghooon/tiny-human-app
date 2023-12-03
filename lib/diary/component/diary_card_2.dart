import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';

import '../../common/constant/data.dart';

class DiaryCard2 extends StatelessWidget {
  final int id;
  final String detail;
  final Image? image;
  final DateTime createdAt;
  final int afterBirthDay;

  const DiaryCard2(
      {required this.id,
      required this.detail,
      required this.createdAt,
      required this.afterBirthDay,
      this.image,
      super.key});

  factory DiaryCard2.fromDiaryModel({
    required DiaryResponseModel model,
  }) {
    return DiaryCard2(
      id: model.id,
      image: Image.network(
        '$S3_BASE_URL${model.pictures.first.keyName}',
        width: 180,
        height: 180,
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
      width: MediaQuery.of(context).size.width / 2,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PRIMARY_COLOR.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
              color: PRIMARY_COLOR.withOpacity(0.1),
              spreadRadius: 10,
              blurRadius: 40,
              blurStyle: BlurStyle.outer),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24.0),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), child: image),
              Positioned(
                width: 180,
                top: 10.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '${createdAt.year}년 ${createdAt.month}월 ${createdAt.day}일',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          backgroundColor: PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('+$afterBirthDay일',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            backgroundColor: PRIMARY_COLOR,
                          )),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Container(
            width: 220,
            child: Text(
              detail,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.0,
                color: BODY_TEXT_COLOR,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
