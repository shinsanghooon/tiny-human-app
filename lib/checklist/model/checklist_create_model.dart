import 'package:json_annotation/json_annotation.dart';

import 'checklistdetail_create_model.dart';

part 'checklist_create_model.g.dart';

@JsonSerializable()
class ChecklistCreateModel {
  final String title;
  final List<ChecklistDetailCreateModel> checklistDetailCreate;

  ChecklistCreateModel(
      {required this.title, required this.checklistDetailCreate});

  factory ChecklistCreateModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistCreateModelToJson(this);
}
