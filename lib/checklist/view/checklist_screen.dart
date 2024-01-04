import 'package:flutter/material.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';
import 'package:tiny_human_app/checklist/view/checklist_detail_screen.dart';

import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import 'checklist_register_screen.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  List<ChecklistModel> datas = [
    ChecklistModel(
      title: '문화센터 갈 때',
      checklist: [
        ChecklistDetailModel(content: '속옷', isChecked: true),
        ChecklistDetailModel(content: '기저귀', isChecked: false),
        ChecklistDetailModel(content: '분유', isChecked: false),
      ],
    ),
    ChecklistModel(
      title: '놀러갈때',
      checklist: [
        ChecklistDetailModel(content: '속옷', isChecked: true),
        ChecklistDetailModel(content: '기저귀', isChecked: false),
        ChecklistDetailModel(content: '분유', isChecked: false),
        ChecklistDetailModel(content: '홈캠', isChecked: false),
      ],
    ),
    ChecklistModel(
      title: '여행',
      checklist: [
        ChecklistDetailModel(content: '속옷', isChecked: true),
        ChecklistDetailModel(content: '기저귀', isChecked: false),
        ChecklistDetailModel(content: '분유', isChecked: false),
        ChecklistDetailModel(content: '홈캠', isChecked: false),
        ChecklistDetailModel(content: '이불', isChecked: false),
        ChecklistDetailModel(content: '이유식', isChecked: false),
      ],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        appBar: AppBar(
          title: const Text(
            "CHECK LIST",
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
                      builder: (_) => const ChecklistRegisterScreen(),
                    ),
                  );
                })
          ],
        ),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              height: 80,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  print('$index');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChecklistDetailScreen(
                          checklist: datas[index].checklist)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        datas[index].title,
                        style: const TextStyle(
                          fontSize: 24.0,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1.0,
              thickness: 0.8,
              indent: 16.0,
              endIndent: 16.0,
            );
          },
          itemCount: datas.length,
        ));
  }
}
