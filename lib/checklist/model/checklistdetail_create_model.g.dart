// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklistdetail_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistDetailCreateModel _$ChecklistDetailCreateModelFromJson(
        Map<String, dynamic> json) =>
    ChecklistDetailCreateModel(
      id: json['id'] as int?,
      contents: json['contents'] as String,
      reason: json['reason'] as String,
      isChecked: json['isChecked'] as bool?,
    );

Map<String, dynamic> _$ChecklistDetailCreateModelToJson(
        ChecklistDetailCreateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contents': instance.contents,
      'reason': instance.reason,
      'isChecked': instance.isChecked,
    };
