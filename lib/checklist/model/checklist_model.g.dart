// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistModel _$ChecklistModelFromJson(Map<String, dynamic> json) =>
    ChecklistModel(
      title: json['title'] as String,
      checklist: (json['checklist'] as List<dynamic>)
          .map((e) => ChecklistDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DataUtils.stringToDateTime(json['createdAt'] as String?),
      updatedAt: DataUtils.stringToDateTime(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$ChecklistModelToJson(ChecklistModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'checklist': instance.checklist,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
