import 'package:flutter/material.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';
import 'package:tiny_human_app/common/component/checkbox.dart';
import 'package:tiny_human_app/common/layout/default_layout.dart';

import '../../common/constant/colors.dart';

class ChecklistDetailScreen extends StatefulWidget {
  final List<ChecklistDetailModel> checklist;

  const ChecklistDetailScreen({required this.checklist, super.key});

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    List<ChecklistDetailModel> checklists = widget.checklist;

    return DefaultLayout(
        appBar: AppBar(
          title: const Text(
            "CHECK LIST",
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w800,
            ),
          ),
          foregroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                icon: const Icon(Icons.more_horiz, color: PRIMARY_COLOR),
                onPressed: () {
                  print('gg');
                })
          ],
        ),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return IntrinsicHeight(
              child: Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomCheckBox(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              checklists[index].content,
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            // if (index % 2 == 0)
                            //   Text(
                            //     '갑자기 똥을 쌀 수 있기 때문에 여분의 옷이 필요함. 똥테러 당하면 답이 없음',
                            //     style: const TextStyle(
                            //       fontSize: 14.0,
                            //     ),
                            //     overflow: TextOverflow.ellipsis,
                            //   )
                          ],
                        ),
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
              thickness: 0.5,
              indent: 16.0,
              endIndent: 16.0,
            );
          },
          itemCount: checklists.length,
        ));
  }
}
