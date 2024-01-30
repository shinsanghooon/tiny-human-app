import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';
import 'package:tiny_human_app/checklist/view/checklist_update_screen.dart';

import '../../common/component/checkbox.dart';
import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../provider/checklist_provider.dart';
import 'checklist_register_screen.dart';

class CheckListScreen extends ConsumerStatefulWidget {
  const CheckListScreen({super.key});

  @override
  ConsumerState<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends ConsumerState<CheckListScreen> {
  @override
  Widget build(BuildContext context) {
    final List<ChecklistModel> data = ref.watch(checklistProvider);

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
          surfaceTintColor: Colors.white,
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
                data[index].title,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                ...checklistWidget(data[index], context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _toggleAllChecklistDetailButton(data[index]),
                    _checklistEditButton(data[index]),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: _todoDeleteButton(data[index].id),
                    ),
                  ],
                )
              ],
            );
          },
          itemCount: data.length,
        ));
  }

  IconButton _todoDeleteButton(int checklistId) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      onPressed: () async {
        await Future.delayed(Duration.zero);
        await _checkDeleteMenuDialog(checklistId);
      },
      icon: const Icon(
        Icons.delete_outlined,
        size: 28.0,
      ),
    );
  }

  Future<void> _checkDeleteMenuDialog(int checklistId) async {
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
            ref.read(checklistProvider.notifier).deleteChecklist(checklistId);
            Navigator.of(context).pop();
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

  IconButton _checklistEditButton(ChecklistModel data) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      onPressed: () {
        print('edit checklist');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChecklistUpdateScreen(model: data)));
      },
      icon: const Icon(
        Icons.edit,
        size: 28.0,
      ),
    );
  }

  IconButton _toggleAllChecklistDetailButton(ChecklistModel checklist) {
    return IconButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: PRIMARY_COLOR,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        onPressed: () {
          ref
              .read(checklistProvider.notifier)
              .toggleAllChecklistDetail(checklist.id);
        },
        icon: const Icon(
          Icons.checklist,
          size: 28.0,
        ));
  }

  List<Padding> checklistWidget(
      ChecklistModel checklistModel, BuildContext context) {
    return checklistModel.checklistDetail.map((checkDetail) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCheckBox(
              isChecked: checkDetail.isChecked,
              onCheckChanged: (bool? newValue) {
                ref
                    .read(checklistProvider.notifier)
                    .toggleChecklistDetail(checklistModel.id, checkDetail.id);
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    checkDetail.contents,
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
