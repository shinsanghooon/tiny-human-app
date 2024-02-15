// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChecklistModel _$ChecklistModelFromJson(Map<String, dynamic> json) =>
    ChecklistModel(
      id: json['id'] as int,
      title: json['title'] as String,
      checklistDetail: (json['checklistDetail'] as List<dynamic>)
          .map((e) => ChecklistDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateConvertor.stringToDateTime(json['createdAt'] as String?),
      updatedAt: DateConvertor.stringToDateTime(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$ChecklistModelToJson(ChecklistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'checklistDetail': instance.checklistDetail,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
