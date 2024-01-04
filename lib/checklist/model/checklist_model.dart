import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';

import '../../common/utils/data_utils.dart';

part 'checklist_model.g.dart';

@JsonSerializable()
class ChecklistModel {
  final String title;
  final List<ChecklistDetailModel> checklist;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime? createdAt;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime? updatedAt;

  ChecklistModel(
      {required this.title,
      required this.checklist,
      this.createdAt,
      this.updatedAt});

  factory ChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistModelFromJson(json);
}
