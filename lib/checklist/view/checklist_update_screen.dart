import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';
import 'package:tiny_human_app/checklist/provider/checklist_provider.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/component/custom_text_checklist_form_field.dart';
import '../../common/component/custom_text_title_form_field.dart';
import '../../common/constant/colors.dart';

class ChecklistUpdateScreen extends ConsumerStatefulWidget {
  // TODO id 받아서 모델을 조회 해오거나 캐싱을 조회하는 방식으로 변경
  final ChecklistModel model;

  const ChecklistUpdateScreen({
    required this.model,
    super.key,
  });

  @override
  ConsumerState<ChecklistUpdateScreen> createState() =>
      _ChecklistUpdateScreenState();
}

class _ChecklistUpdateScreenState extends ConsumerState<ChecklistUpdateScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String? title;
  String? originalTitle;
  List<ChecklistDetailModel> newChecklistDetails = [];
  late ChecklistModel updateChecklist;

  @override
  void initState() {
    super.initState();
    updateChecklist = widget.model; // 부모로부터 전달받은 값을 사용하여 상태 초기화
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: checklistAppbar(context),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "제목",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                    titleTextCard(updateChecklist.id, updateChecklist.title),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "체크리스트",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return checklistTextCard(index);
                      },
                      itemCount: updateChecklist.checklistDetail.length,
                    ),
                  ],
                ),
              ), // ...checklistsWidgets,
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
                          int maxId = get_detail_max_id();

                          setState(() {
                            updateChecklist = ChecklistModel(
                                id: updateChecklist.id,
                                title: updateChecklist.title,
                                checklistDetail: [
                                  ...updateChecklist.checklistDetail,
                                  ChecklistDetailModel(
                                    id: Random().nextInt(1000) + (maxId + 1),
                                    contents: '',
                                    reason: '',
                                  ),
                                ]);
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

  int get_detail_max_id() {
    int maxId = updateChecklist.checklistDetail
        .map((item) => item.id)
        .fold(0, (currentMax, id) => id > currentMax ? id : currentMax);
    return maxId;
  }

  AppBar checklistAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        "체크리스트 수정",
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
        onSaved: (String? value) {
          title = value;
        },
        hintText: "체크리스트 제목을 입력해주세요.",
        initialValue: originalTitle!,
      ),
    );
  }

  Widget checklistTextCard(int index) {
    ChecklistDetailModel checklistDetail =
        updateChecklist.checklistDetail[index];

    return SizedBox(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: CustomTextChecklistFormField(
                  keyName: 'checklist_detail_update_${checklistDetail.id}',
                  onSaved: (String? value) {
                    int maxId = get_detail_max_id();
                    newChecklistDetails.add(ChecklistDetailModel(
                      id: Random().nextInt(1000) + (maxId + 1),
                      contents: value!,
                      reason: '',
                    ));
                  },
                  hintText: "체크할 항목을 입력해주세요.",
                  initialValue: checklistDetail.contents,
                ),
              ),
            ),
            Container(
              width: 50,
              color: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.delete_outlined,
                  color: Colors.black38,
                ),
                onPressed: () {
                  setState(() {
                    updateChecklist = ChecklistModel(
                        id: updateChecklist.id,
                        title: updateChecklist.title,
                        checklistDetail: updateChecklist.checklistDetail
                            .where((detail) => detail.id != checklistDetail.id)
                            .toList());
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        // create new model
        // and request API!
        // cache reset!
        if (formKey.currentState == null) {
          return null;
        }

        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
        } else {
          return null;
        }

        updateChecklist = ChecklistModel(
            id: updateChecklist.id,
            title: title!,
            checklistDetail: [...newChecklistDetails]);

        ref.read(checklistProvider.notifier).updateChecklist(updateChecklist);

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
