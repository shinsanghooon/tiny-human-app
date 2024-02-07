import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/checklist/model/checklist_create_model.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/component/custom_text_checklist_form_field.dart';
import '../../common/component/custom_text_title_form_field.dart';
import '../../common/constant/colors.dart';
import '../provider/checklist_provider.dart';

class ChecklistUpdateScreen extends ConsumerStatefulWidget {
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
  List<ChecklistDetailModel> newChecklistDetails = [];
  List<int> deleteChecklistDetails = [];
  List<int> originalChecklistDetailIds = [];
  late ChecklistModel originalChecklist;

  @override
  void initState() {
    super.initState();
    originalChecklist = widget.model; // 부모로부터 전달받은 값을 사용하여 상태 초기화
    originalChecklistDetailIds =
        originalChecklist.checklistDetail.map((e) => e.id).toList();
  }

  int generateTemporaryId() {
    List<ChecklistDetailModel> targetList = [
      ...originalChecklist.checklistDetail,
      ...newChecklistDetails
    ];
    List<int> existingIds = targetList.map((e) => e.id).toList();
    if (existingIds.isEmpty) {
      return 1; // 리스트가 비어있을 경우 기본값으로 1을 사용
    }
    return existingIds.reduce(max) +
        1 +
        Random().nextInt(10000); // 가장 큰 id 값에 1을 더함
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: _checklistAppbar(context),
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
                    _titleTextCard(
                        originalChecklist.id, originalChecklist.title),
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
                        return _checklistTextCard(index);
                      },
                      itemCount: originalChecklist.checklistDetail.length,
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
                          // 신규 리스트 생성
                          final newChecklistDetail = ChecklistDetailModel(
                            id: generateTemporaryId(),
                            contents: '',
                            reason: '',
                          );
                          newChecklistDetails.add(newChecklistDetail);
                          setState(() {
                            originalChecklist = ChecklistModel(
                                id: originalChecklist.id,
                                title: originalChecklist.title,
                                checklistDetail: [
                                  ...originalChecklist.checklistDetail,
                                  newChecklistDetail,
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
              registerActionButton(context, '수정하기'),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _checklistAppbar(BuildContext context) {
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

  Widget _titleTextCard(int id, String? originalTitle) {
    return SizedBox(
      child: CustomTextTitleFormField(
        keyName: 'checklist_update_${id}_${UniqueKey()}',
        onSaved: (String? value) {
          originalChecklist = ChecklistModel(
              id: originalChecklist.id,
              title: value!,
              checklistDetail: originalChecklist.checklistDetail);
        },
        hintText: "체크리스트 제목을 입력해주세요.",
        initialValue: originalTitle!,
      ),
    );
  }

  Widget _checklistTextCard(int index) {
    ChecklistDetailModel checklistDetail =
        originalChecklist.checklistDetail[index];

    return SizedBox(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: CustomTextChecklistFormField(
                  keyName: '${checklistDetail.id}_${UniqueKey()}',
                  onSaved: (String? value) {
                    setState(() {
                      originalChecklist = ChecklistModel(
                          id: originalChecklist.id,
                          title: originalChecklist.title,
                          checklistDetail: originalChecklist.checklistDetail
                              .map((e) => e.id == checklistDetail.id
                                  ? ChecklistDetailModel(
                                      id: e.id,
                                      contents: value!,
                                      reason: e.reason,
                                      isChecked: e.isChecked,
                                    )
                                  : e)
                              .toList());
                    });
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
                  // 기존 존재하는 detail 중에 삭제된 것
                  if (originalChecklistDetailIds.contains(checklistDetail.id)) {
                    deleteChecklistDetails.add(checklistDetail.id);
                  }
                  print(deleteChecklistDetails);

                  // 새로 추가한 detail list 중에서 삭제되면 여기서 제외
                  newChecklistDetails = newChecklistDetails
                      .where((element) => element.id != checklistDetail.id)
                      .toList();

                  setState(() {
                    originalChecklist = ChecklistModel(
                        id: originalChecklist.id,
                        title: originalChecklist.title,
                        checklistDetail: originalChecklist.checklistDetail
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

        ChecklistCreateModel updatedModel =
            ChecklistCreateModel.fromModel(originalChecklist);

        ref.read(checklistProvider.notifier).updateChecklist(updatedModel);

        // delete 도 따로 해줘야하나? ㅇㅇ

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
