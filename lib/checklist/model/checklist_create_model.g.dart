// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistCreateModel _$ChecklistCreateModelFromJson(
        Map<String, dynamic> json) =>
    ChecklistCreateModel(
      title: json['title'] as String,
      checklistDetailCreate: (json['checklistDetailCreate'] as List<dynamic>)
          .map((e) =>
              ChecklistDetailCreateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChecklistCreateModelToJson(
        ChecklistCreateModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'checklistDetailCreate': instance.checklistDetailCreate,
    };
