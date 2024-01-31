import 'package:json_annotation/json_annotation.dart';

part 'checklistdetail_create_model.g.dart';

@JsonSerializable()
class ChecklistDetailCreateModel {
  final String contents;
  final String reason;

  ChecklistDetailCreateModel({required this.contents, required this.reason});

  factory ChecklistDetailCreateModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistDetailCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistDetailCreateModelToJson(this);
}
