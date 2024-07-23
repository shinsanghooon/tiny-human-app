import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/checklist/model/checklist_create_model.dart';
import 'package:tiny_human_app/checklist/model/checklistdetail_create_model.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/component/custom_text_checklist_form_field.dart';
import '../../common/component/custom_text_title_form_field.dart';
import '../../common/component/loading_spinner.dart';
import '../../common/constant/colors.dart';
import '../provider/checklist_provider.dart';

class ChecklistRegisterScreen extends ConsumerStatefulWidget {
  const ChecklistRegisterScreen({super.key});

  @override
  ConsumerState<ChecklistRegisterScreen> createState() => _ChecklistRegisterScreenState();
}

class _ChecklistRegisterScreenState extends ConsumerState<ChecklistRegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String title = '';
  List<ChecklistDetailCreateModel> checklistDetails = [];
  List<FocusNode> focusNodes = [];
  bool isLoading = false;

  @override
  void initState() {
    checklistDetails.add(ChecklistDetailCreateModel(contents: '', reason: ''));
    focusNodes.add(FocusNode());
    super.initState();
  }

  @override
  void dispose() {
    for (FocusNode node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: checklistAppbar(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleTextCard(),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 4.0),
                      itemBuilder: (context, index) {
                        return checklistTextCard(index);
                      },
                      itemCount: checklistDetails.length,
                    ),
                  ],
                ),
              ),
              // ...checklistsWidgets,
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
                            checklistDetails.add(ChecklistDetailCreateModel(contents: '', reason: ''));
                            focusNodes.add(FocusNode());
                          });
                          // Delay the focus request to ensure the widget tree is updated
                          // WidgetsBinding.instance.addPostFrameCallback 사용
                          // - WidgetsBinding.instance.addPostFrameCallback을 사용하여 위젯 트리가 업데이트된 후 포커스를 설정합니다.
                          // - 이렇게 하면 setState가 호출된 후 새로 추가된 TextFormField가 포커스를 받을 수 있습니다.
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FocusScope.of(context).requestFocus(focusNodes.last);
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
                height: 20.0,
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
      toolbarHeight: 64.0,
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
      child: Row(
        children: [
          Expanded(
            child: CustomTextChecklistFormField(
              keyName: 'checklist_detail_$idx',
              focusNode: focusNodes[idx],
              onSaved: (String? value) {
                checklistDetails[idx] = ChecklistDetailCreateModel(contents: value!, reason: '');
              },
              onChanged: (String? value) {
                checklistDetails[idx] = ChecklistDetailCreateModel(contents: value!, reason: '');
              },
              hintText: "체크할 항목을 입력해주세요.",
              initialValue: checklistDetails[idx].contents,
            ),
          ),
          Container(
            width: 50,
            color: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.delete_outlined,
                color: Colors.black38,
                size: 20.0,
              ),
              onPressed: () {
                setState(() {
                  checklistDetails.removeAt(idx);
                  focusNodes.removeAt(idx).dispose();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  SizedBox registerActionButton(BuildContext context, String buttonText) {
    return SizedBox(
      height: 46.0,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          if (formKey.currentState == null) {
            setState(() {
              isLoading = false;
            });

            return null;
          }

          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
          } else {
            setState(() {
              isLoading = false;
            });

            return null;
          }

          ChecklistCreateModel checklistCreateModel = ChecklistCreateModel(
            title: title,
            checklistDetailCreate: checklistDetails,
          );

          await ref.read(checklistProvider.notifier).addChecklist(checklistCreateModel);

          if (mounted) {
            setState(() {
              isLoading = false;
            });
            GoRouter.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
        ),
        child: isLoading
            ? const LoadingSpinner()
            : Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
