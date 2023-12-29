import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/baby/view/baby_register_screen.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../component/baby_card_two.dart';
import '../provider/baby_provider.dart';

class BabyScreen extends ConsumerWidget {
  static String get routeName => 'baby';

  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 어떤 순간에서든 babyProvider 사용하게 되면
    // 이 화면에서든 어떤 화면에서든 한 번 불리면 프로바이더가 생성이 되고 계속 기억이 된다.
    // 이제 future builder가 필요가 없다.
    final data = ref.watch(babyProvider);

    print(data);

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
            icon: const Icon(Icons.home_outlined, color: PRIMARY_COLOR),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.add, color: PRIMARY_COLOR),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BabyRegisterScreen(),
                    ),
                  );
                })
          ],
        ),
        if (data.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = data[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: BabyCardTwo(model: item),
                  );
                },
                childCount: data.length,
              ),
            ),
          )
      ]),
    );
  }
}
