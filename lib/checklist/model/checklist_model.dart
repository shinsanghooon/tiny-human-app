import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';

import '../../common/utils/date_convertor.dart';

part 'checklist_model.g.dart';

@JsonSerializable()
class ChecklistModel {
  final int id;
  final String title;
  List<ChecklistDetailModel> checklistDetail;
  @JsonKey(
    fromJson: DateConvertor.stringToDateTime,
  )
  final DateTime? createdAt;
  @JsonKey(
    fromJson: DateConvertor.stringToDateTime,
  )
  final DateTime? updatedAt;

  ChecklistModel(
      {required this.id, required this.title, required this.checklistDetail, this.createdAt, this.updatedAt});

  factory ChecklistModel.fromJson(Map<String, dynamic> json) => _$ChecklistModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistModelToJson(this);
}
