// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklistdetail_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistDetailCreateModel _$ChecklistDetailCreateModelFromJson(
        Map<String, dynamic> json) =>
    ChecklistDetailCreateModel(
      content: json['content'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$ChecklistDetailCreateModelToJson(
        ChecklistDetailCreateModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'reason': instance.reason,
    };
