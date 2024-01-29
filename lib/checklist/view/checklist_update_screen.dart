import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';
import 'package:tiny_human_app/checklist/provider/checklist_provider.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/component/custom_text_checklist_form_field.dart';
import '../../common/component/custom_text_title_form_field.dart';
import '../../common/constant/colors.dart';

class ChecklistUpdateScreen extends ConsumerStatefulWidget {
  // TODO id 받아서 모델을 조회 해오거나 캐싱을 조회하는 방식으로 변경
  final int id;

  const ChecklistUpdateScreen({
    required this.id,
    super.key,
  });

  @override
  ConsumerState<ChecklistUpdateScreen> createState() =>
      _ChecklistUpdateScreenState();
}

class _ChecklistUpdateScreenState extends ConsumerState<ChecklistUpdateScreen> {
  String? title;
  String? originalTitle;

  @override
  Widget build(BuildContext context) {
    final ChecklistModel updateChecklist =
        ref.read(checklistProvider.notifier).getChecklist(widget.id);

    return DefaultLayout(
      appBar: checklistAppbar(context),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              titleTextCard(1, updateChecklist.title),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Checklist",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return checklistTextCard(
                        index, updateChecklist.checklistDetail[index].contents);
                  },
                  itemCount: updateChecklist.checklistDetail.length),
              // ...checklistsWidgets,
              const SizedBox(
                height: 8.0,
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  const Divider(
                    thickness: 0.3,
                    color: PRIMARY_COLOR,
                  ),
                  Positioned(
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            print('update');
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 36.0,
              ),
              registerActionButton(context, '등록'),
            ],
          ),
        ),
      ),
    );
  }

  AppBar checklistAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        "체크리스트 등록",
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: PRIMARY_COLOR),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  Widget titleTextCard(int id, String? originalTitle) {
    return SizedBox(
      child: CustomTextTitleFormField(
        keyName: 'checklist_update_$id',
        // textEditingController: textEditingController,
        onChanged: (String? value) {
          title = value;
        },
        onSaved: (String? value) {
          print('checklist title onSaved');
          title = value;
        },
        hintText: "체크리스트 제목을 입력해주세요.",
        initialValue: originalTitle!,
      ),
    );
  }

  Widget checklistTextCard(int id, String? content) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: SizedBox(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: CustomTextChecklistFormField(
                    keyName: 'checklist_detail_update_$id',
                    onChanged: (String? value) {
                      print(value);
                    },
                    onSaved: (String? value) {
                      print('checklist onSaved');
                    },
                    hintText: "체크할 항목을 입력해주세요.",
                    initialValue: content!,
                  ),
                ),
              ),
              Container(
                width: 50,
                color: Colors.green,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outlined,
                    color: Colors.black38,
                  ),
                  onPressed: () {
                    // TODO: Delete Item
                    print('delete item');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        print('체크리스트를 등록하자.');

        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: PRIMARY_COLOR,
      ),
      child: Center(
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
