import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/checklist/model/checklist_create_model.dart';
import 'package:tiny_human_app/checklist/model/checklistdetail_create_model.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/component/custom_text_checklist_form_field.dart';
import '../../common/component/custom_text_title_form_field.dart';
import '../../common/constant/colors.dart';
import '../provider/checklist_provider.dart';

class ChecklistRegisterScreen extends ConsumerStatefulWidget {
  const ChecklistRegisterScreen({super.key});

  @override
  ConsumerState<ChecklistRegisterScreen> createState() =>
      _ChecklistRegisterScreenState();
}

class _ChecklistRegisterScreenState
    extends ConsumerState<ChecklistRegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String title = '';
  List<ChecklistDetailCreateModel> checklistDetails = [];

  @override
  void initState() {
    checklistDetails.add(ChecklistDetailCreateModel(contents: '', reason: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: checklistAppbar(context),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    titleTextCard(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      "Checklist",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return checklistTextCard(index);
                      },
                      itemCount: checklistDetails.length,
                    ),
                  ],
                ),
              ),
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
                            checklistDetails.add(ChecklistDetailCreateModel(
                                contents: '', reason: ''));
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

  Widget titleTextCard() {
    return SizedBox(
      child: CustomTextTitleFormField(
        keyName: 'checklist_new_title',
        onSaved: (String? value) {
          title = value!;
        },
        hintText: "체크리스트 제목을 입력해주세요.",
        initialValue: '',
      ),
    );
  }

  Widget checklistTextCard(int idx) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: CustomTextChecklistFormField(
        keyName: 'checklist_detail_$idx',
        onSaved: (String? value) {
          checklistDetails[idx] =
              ChecklistDetailCreateModel(contents: value!, reason: '');
        },
        hintText: "체크할 항목을 입력해주세요.",
        initialValue: '',
      ),
    );
  }

  TextButton registerActionButton(BuildContext context, String buttonText) {
    return TextButton(
      onPressed: () {
        print('체크리스트를 등록하자.');
        if (formKey.currentState == null) {
          return null;
        }

        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
        } else {
          return null;
        }

        ChecklistCreateModel checklistCreateModel = ChecklistCreateModel(
          title: title,
          checklistDetailCreate: checklistDetails,
        );

        ref.read(checklistProvider.notifier).addChecklist(checklistCreateModel);

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
