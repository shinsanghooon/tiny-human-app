import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';

part 'checklistdetail_create_model.g.dart';

@JsonSerializable()
class ChecklistDetailCreateModel {
  int? id;
  final String contents;
  final String reason;
  bool? isChecked;

  ChecklistDetailCreateModel(
      {this.id, required this.contents, required this.reason, this.isChecked});

  factory ChecklistDetailCreateModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistDetailCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistDetailCreateModelToJson(this);

  static ChecklistDetailCreateModel fromModel(
          ChecklistDetailModel checklistDetailModel) =>
      ChecklistDetailCreateModel(
          id: checklistDetailModel.id,
          contents: checklistDetailModel.contents,
          reason: checklistDetailModel.reason,
          isChecked: checklistDetailModel.isChecked);
}
