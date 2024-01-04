import 'package:json_annotation/json_annotation.dart';

part 'checklist_detail_model.g.dart';

@JsonSerializable()
class ChecklistDetailModel {
  final String content;
  final bool isChecked;

  ChecklistDetailModel({
    required this.content,
    this.isChecked = false,
  });

  factory ChecklistDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistDetailModelFromJson(json);
}
