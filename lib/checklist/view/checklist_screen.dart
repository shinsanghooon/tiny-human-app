import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';

import '../../common/component/checkbox.dart';
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
      title: '😀 문화센터 갈 때',
      checklist: [
        ChecklistDetailModel(content: '속옷', isChecked: true),
        ChecklistDetailModel(content: '기저귀', isChecked: false),
        ChecklistDetailModel(content: '분유', isChecked: false),
      ],
    ),
    ChecklistModel(
      title: '🚗 멀리 여행갈 때',
      checklist: [
        ChecklistDetailModel(content: '속옷', isChecked: true),
        ChecklistDetailModel(content: '기저귀', isChecked: false),
        ChecklistDetailModel(content: '분유', isChecked: false),
        ChecklistDetailModel(content: '홈캠', isChecked: false),
        ChecklistDetailModel(content: '이불', isChecked: false),
        ChecklistDetailModel(content: '이유식', isChecked: false),
      ],
    ),
    ChecklistModel(
      title: '☕️ 동네 카페',
      checklist: [
        ChecklistDetailModel(content: '속옷', isChecked: true),
        ChecklistDetailModel(content: '기저귀', isChecked: false),
        ChecklistDetailModel(content: '우유', isChecked: false),
        ChecklistDetailModel(content: '스티커', isChecked: false),
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
          backgroundColor: Colors.white,
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
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                datas[index].title,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                ...checklistWidget(index, context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _allCheckButton(index),
                    _todoEditButton(),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: _todoDeleteButton(),
                    ),
                  ],
                )
              ],
            );
          },
          itemCount: datas.length,
        ));
  }

  IconButton _todoDeleteButton() {
    return IconButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      onPressed: () async {
        await Future.delayed(Duration.zero);
        await _checkDeleteMenuDialog();
      },
      icon: const Icon(
        Icons.delete_outlined,
        size: 28.0,
      ),
    );
  }

  Future<void> _checkDeleteMenuDialog() async {
    const msgTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );

    const buttonTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18.0,
    );

    return Dialogs.materialDialog(
      msg: '체크리스트를 삭제하시겠습니까?',
      msgStyle: msgTextStyle,
      title: "체크리스트 삭제",
      titleStyle: msgTextStyle.copyWith(fontWeight: FontWeight.w600),
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            if (mounted) {
              // TODO: Go to DiaryDetailScreen
              Navigator.of(context).pop();
            }
          },
          text: '돌아가기',
          color: PRIMARY_COLOR,
          iconData: Icons.cancel_outlined,
          textStyle: buttonTextStyle,
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () async {
            // todo delete request
          },
          text: '삭제하기',
          iconData: Icons.delete,
          color: PRIMARY_COLOR,
          textStyle: buttonTextStyle,
          iconColor: Colors.white,
        ),
      ],
    );
  }

  IconButton _todoEditButton() {
    return IconButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      onPressed: () {
        print('edit checklist');
      },
      icon: const Icon(
        Icons.edit,
        size: 28.0,
      ),
    );
  }

  IconButton _allCheckButton(int index) {
    final allChecklist =
        datas[index].checklist.map((e) => e.isChecked).toList();
    var isAllCheck =
        allChecklist.where((element) => element == false).toList().isEmpty;

    return IconButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: PRIMARY_COLOR,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        onPressed: () {
          setState(
            () {
              isAllCheck
                  ? datas[index].checklist.forEach((e) => e.onCheck())
                  : datas[index].checklist.forEach((e) => e.onCheckTrue());
            },
          );
        },
        icon: const Icon(
          Icons.checklist,
          size: 28.0,
        ));
  }

  List<Padding> checklistWidget(int index, BuildContext context) {
    return datas[index].checklist.map((e) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCheckBox(
              isChecked: e.isChecked,
              onCheckChanged: (bool? newValue) {
                setState(() {
                  e.isChecked = !e.isChecked;
                });
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    e.content,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
