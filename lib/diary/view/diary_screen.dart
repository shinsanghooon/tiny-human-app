import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/baby/view/baby_register_screen.dart';
import 'package:tiny_human_app/diary/component/diary_card.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';

import '../../common/constant/colors.dart';
import '../../common/constant/data.dart';
import '../../common/layout/default_layout.dart';
import 'diary_register_screen.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: CustomScrollView(
          slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "DIARY",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.home_outlined, color: PRIMARY_COLOR),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.add, color: PRIMARY_COLOR),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DiaryRegisterScreen(),
                    ),
                  );
                })
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: DiaryCard.fromDiaryModel(
                    model: DiaryResponseModel(
                      id: 1,
                      daysAfterBirth: 10,
                      writer: "writer",
                      likeCount: 1,
                      isDeleted: false,
                      date: DateTime(2022, 9, 27),
                      sentences: SAMPLE_SENTENCES,
                      pictures: SAMPLE_IMAGES,
                    ),
                  ),
                );
              },
              childCount: 3,
            ),
          ),
        )
      ]),
    );
  }
}
