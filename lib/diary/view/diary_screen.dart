import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/baby/view/baby_screen.dart';
import 'package:tiny_human_app/diary/component/diary_card.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';
import 'package:tiny_human_app/diary/view/diary_detail_screen.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../../common/model/cursor_pagination_model.dart';
import 'diary_register_screen.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  static String get routeName => 'diary';

  const DiaryScreen({super.key});

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    final diaryPagination = ref.watch(diaryPaginationProvider);

    if (diaryPagination is CursorPaginationLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
            child: CircularProgressIndicator(
          color: PRIMARY_COLOR,
        )),
      );
    }

    if (diaryPagination is CursorPaginationError) {
      return Center(
        child: Text("에러가 있습니다. ${diaryPagination.message}"),
      );
    }

    final cp = diaryPagination as CursorPagination;
    final data = cp.body;

    return DefaultLayout(
      child: RefreshIndicator(
        edgeOffset: 120.0, // TODO: AppBar 높이 알아내서 반영하기
        color: PRIMARY_COLOR,

        onRefresh: () async {
          ref
              .read(diaryPaginationProvider.notifier)
              .paginate(forceRefetch: true);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  onPressed: () => context.goNamed(BabyScreen.routeName)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: PRIMARY_COLOR),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DiaryRegisterScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
            SliverList.separated(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DiaryDetailScreen(model: data[index])));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DiaryCard.fromDiaryModel(
                      model: data[index],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 12.0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
