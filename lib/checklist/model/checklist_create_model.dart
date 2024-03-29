import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/checklist/model/checklist_model.dart';

import 'checklistdetail_create_model.dart';

part 'checklist_create_model.g.dart';

@JsonSerializable()
class ChecklistCreateModel {
  int? id;
  final String title;
  final List<ChecklistDetailCreateModel> checklistDetailCreate;

  ChecklistCreateModel(
      {this.id, required this.title, required this.checklistDetailCreate});

  factory ChecklistCreateModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistCreateModelToJson(this);

  static ChecklistCreateModel fromModel(ChecklistModel checklistModel) =>
      ChecklistCreateModel(
          id: checklistModel.id,
          title: checklistModel.title,
          checklistDetailCreate: checklistModel.checklistDetail
              .map((e) => ChecklistDetailCreateModel.fromModel(e))
              .toList());
}
