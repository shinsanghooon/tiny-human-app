import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/component/custom_text_checklist_form_field.dart';
import '../../common/component/custom_text_title_form_field.dart';
import '../../common/constant/colors.dart';

class ChecklistRegisterScreen extends StatefulWidget {
  const ChecklistRegisterScreen({super.key});

  @override
  State<ChecklistRegisterScreen> createState() =>
      _ChecklistRegisterScreenState();
}

class _ChecklistRegisterScreenState extends State<ChecklistRegisterScreen> {
  String? title;
  List<String> checklists = [];

  @override
  void initState() {
    checklists.add('');
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
              const Text(
                "Title",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
              titleTextCard(1),
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
                  return checklistTextCard(index, checklists[index]);
                },
                itemCount: checklists.length,
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
                            checklists.add('');
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

  Widget titleTextCard(int id) {
    return SizedBox(
      child: CustomTextTitleFormField(
        keyName: 'checklist_$id',
        // textEditingController: textEditingController,
        onChanged: (String? value) {
          title = value;
        },
        onSaved: (String? value) {
          print('checklist title onSaved');
          title = value;
        },
        hintText: "체크리스트 제목을 입력해주세요.",
        initialValue: '',
      ),
    );
  }

  Widget checklistTextCard(int id, String? content) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: CustomTextChecklistFormField(
        keyName: 'checklist_detail_$id',
        onChanged: (String? value) {
          checklists[id] = value!;
          print(checklists);
        },
        onSaved: (String? value) {
          print('checklist onSaved');
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
