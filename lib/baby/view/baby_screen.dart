import 'package:flutter/material.dart';
import 'package:tiny_human_app/baby/view/baby_register_screen.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../component/baby_card.dart';

class BabyScreen extends StatelessWidget {
  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "BABY",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w800,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.home_outlined, color: PRIMARY_COLOR),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: PRIMARY_COLOR),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BabyRegisterScreen(),
                  ),
                );
              }
            )
          ],
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: BabyCard(
                    name: '신리카',
                    gender: '여자',
                    birth: '2022년 9월 27일',
                    description:
                        "서울 은평구 인정병원에서 22년 9월 27일 14시에 56cm, 4.1kg의 자이언트 베이비로 태어남. 태어나자마자 똥을 쌌다고 전해짐. ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ",
                  ),
                );
              },
              childCount: 10,
            ),
          ),
        )
      ]),
    );
  }
}
