import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/baby/component/baby_card.dart';
import 'package:tiny_human_app/user/provider/auth_provider.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../provider/baby_provider.dart';
import 'baby_register_screen.dart';

class BabyScreen extends ConsumerWidget {
  static String get routeName => '/';

  const BabyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 어떤 순간에서든 babyProvider 사용하게 되면
    // 이 화면에서든 어떤 화면에서든 한 번 불리면 프로바이더가 생성이 되고 계속 기억이 된다.
    // 이제 future builder가 필요가 없다.
    final data = ref.watch(babyProvider);

    return DefaultLayout(
      appBar: AppBar(
        title: const Text(
          "BABY HOME",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w800,
          ),
        ),
        toolbarHeight: 64.0,
        leading: Transform.rotate(
          angle: math.pi,
          child: IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: PRIMARY_COLOR,
            ),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
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
      child: Padding(
        padding: const EdgeInsets.only(top: 00.0),
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) => SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: BabyCard(model: data[index]),
            ),
          ),
        ),
      ),
    );
  }
}
