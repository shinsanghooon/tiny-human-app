import 'package:json_annotation/json_annotation.dart';

part 'checklist_detail_model.g.dart';

@JsonSerializable()
class ChecklistDetailModel {
  final int id;
  final String contents;
  final String reason;
  bool isChecked;

  ChecklistDetailModel({
    required this.id,
    required this.contents,
    required this.reason,
    this.isChecked = false,
  });

  factory ChecklistDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistDetailModelFromJson(json);

}
