import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';
import 'package:tiny_human_app/checklist/view/checklist_update_screen.dart';

import '../../common/component/checkbox.dart';
import '../../common/component/leading_logo_icon.dart';
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
          toolbarHeight: 64.0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: const LeadingLogoIcon(),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: _checklistTitle(data, index),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                children: [
                  ...checklistWidget(data[index], context),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _toggleAllChecklistDetailButton(data[index]),
                        _checklistEditButton(data[index]),
                        _todoDeleteButton(data[index].id),
                      ],
                    ),
                  )
                ],
              );
            },
            itemCount: data.length,
            separatorBuilder: (context, index) => const Divider(
              color: DIVIDER_COLOR,
              indent: 16.0,
              endIndent: 16.0,
              height: 0.0,
            ),
          ),
        ));
  }

  Widget _checklistTitle(List<ChecklistModel> data, int index) {
    bool detailAllChecked = data[index].checklistDetail.every((detail) => detail.isChecked == true);
    return detailAllChecked
        ? Row(
            children: [
              Text(
                data[index].title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(
                Icons.check_circle_outline_outlined,
                color: MAIN_GREEN_COLOR,
                size: 20.0,
              )
            ],
          )
        : Text(
            data[index].title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          );
  }

  IconButton _todoDeleteButton(int checklistId) {
    return IconButton(
      visualDensity: VisualDensity.compact,
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
        size: 20.0,
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
      visualDensity: VisualDensity.compact,
      style: ElevatedButton.styleFrom(
        foregroundColor: PRIMARY_COLOR,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChecklistUpdateScreen(
                  model: data,
                )));
      },
      icon: const Icon(
        Icons.edit,
        size: 20.0,
      ),
    );
  }

  IconButton _toggleAllChecklistDetailButton(ChecklistModel checklist) {
    return IconButton(
        visualDensity: VisualDensity.compact,
        style: ElevatedButton.styleFrom(
          foregroundColor: PRIMARY_COLOR,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        onPressed: () {
          ref.read(checklistProvider.notifier).toggleAllChecklistDetail(checklist.id);
        },
        icon: const Icon(
          Icons.checklist,
          size: 20.0,
        ));
  }

  List<Padding> checklistWidget(ChecklistModel checklistModel, BuildContext context) {
    return checklistModel.checklistDetail.map((checkDetail) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCheckBox(
              isChecked: checkDetail.isChecked,
              onCheckChanged: (bool? newValue) {
                ref.read(checklistProvider.notifier).toggleChecklistDetail(checklistModel.id, checkDetail.id);
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  checkDetail.isChecked
                      ? Text(
                          checkDetail.contents,
                          style: const TextStyle(
                            fontSize: 18.0,
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                      : Text(
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
