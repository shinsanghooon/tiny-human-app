import 'package:json_annotation/json_annotation.dart';

part 'checklist_detail_model.g.dart';

@JsonSerializable()
class ChecklistDetailModel {
  final int id;
  final String content;
  bool isChecked;

  ChecklistDetailModel({
    required this.id,
    required this.content,
    this.isChecked = false,
  });

  factory ChecklistDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistDetailModelFromJson(json);

  void onCheck() {
    isChecked = !isChecked;
  }

  void onCheckTrue() {
    isChecked = true;
  }
}
