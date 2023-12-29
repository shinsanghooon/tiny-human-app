import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/baby/component/baby_card_two.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../provider/baby_provider.dart';
import 'baby_register_screen.dart';

class BabyScreen extends ConsumerWidget {
  static String get routeName => 'baby';

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
        padding: const EdgeInsets.only(top: 100.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) => SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: BabyCardTwo(model: data[index]),
            ),
          ),
        ),
      ),
    );

    // return DefaultLayout(
    //   child: CustomScrollView(slivers: [
    //     SliverAppBar(
    //       backgroundColor: Colors.transparent,
    //       title: const Text(
    //         "BABY HOME",
    //         style: TextStyle(
    //           color: Colors.deepOrange,
    //           fontWeight: FontWeight.w800,
    //         ),
    //       ),
    //       actions: [
    //         IconButton(
    //             icon: const Icon(Icons.add, color: PRIMARY_COLOR),
    //             onPressed: () {
    //               Navigator.of(context).push(
    //                 MaterialPageRoute(
    //                   builder: (_) => const BabyRegisterScreen(),
    //                 ),
    //               );
    //             })
    //       ],
    //     ),
    //     if (data.isNotEmpty)
    //       SliverPadding(
    //         padding: EdgeInsets.only(
    //           top: MediaQuery.of(context).size.height / 10,
    //         ),
    //         sliver: SliverToBoxAdapter(
    //           child: SizedBox(
    //             height: MediaQuery.of(context).size.height,
    //             child: ListView.builder(
    //               scrollDirection: Axis.horizontal,
    //               itemCount: data.length,
    //               itemBuilder: (context, index) => SizedBox(
    //                   width: MediaQuery.of(context).size.width / 1.1,
    //                   child: Padding(
    //                     padding: const EdgeInsets.only(left: 40.0),
    //                     child: BabyCardTwo(model: data[index]),
    //                   )),
    //             ),
    //           ),
    //         ),
    //       )
    //   ]),
    // );
  }
}
