// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistDetailModel _$ChecklistDetailModelFromJson(
        Map<String, dynamic> json) =>
    ChecklistDetailModel(
      content: json['content'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
    );

Map<String, dynamic> _$ChecklistDetailModelToJson(
        ChecklistDetailModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'isChecked': instance.isChecked,
    };
