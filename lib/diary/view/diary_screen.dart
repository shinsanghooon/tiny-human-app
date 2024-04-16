import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/common/component/leading_logo_icon.dart';
import 'package:tiny_human_app/common/component/pagenation_list_view.dart';
import 'package:tiny_human_app/diary/component/diary_card.dart';
import 'package:tiny_human_app/diary/provider/diary_pagination_provider.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../model/diary_response_model.dart';
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
    return DefaultLayout(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "DIARY",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w800,
            ),
          ),
          toolbarHeight: 64.0,
          leading: const LeadingLogoIcon(),
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
          ]),
      child: PaginationListView<DiaryResponseModel>(
        provider: diaryPaginationProvider,
        itemBuilder: <DiaryResponseModel>(_, index, model) {
          return InkWell(
            onTap: () {
              context.push('/diary/${model.id}', extra: model);
            },
            child: DiaryCard.fromDiaryModel(
              model: model,
            ),
          );
        },
      ),
    );
  }
}
