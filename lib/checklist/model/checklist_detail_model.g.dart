// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistDetailModel _$ChecklistDetailModelFromJson(
        Map<String, dynamic> json) =>
    ChecklistDetailModel(
      id: json['id'] as int,
      contents: json['contents'] as String,
      reason: json['reason'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
    );

Map<String, dynamic> _$ChecklistDetailModelToJson(
        ChecklistDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contents': instance.contents,
      'reason': instance.reason,
      'isChecked': instance.isChecked,
    };
