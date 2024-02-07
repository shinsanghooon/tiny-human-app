// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryCreateModel _$DiaryCreateModelFromJson(Map<String, dynamic> json) =>
    DiaryCreateModel(
      userId: json['userId'] as int,
      babyId: json['babyId'] as int,
      daysAfterBirth: json['daysAfterBirth'] as int,
      likeCount: json['likeCount'] as int,
      date: DateTime.parse(json['date'] as String),
      sentences: (json['sentences'] as List<dynamic>)
          .map((e) => SentenceRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (json['files'] as List<dynamic>)
          .map((e) => DiaryFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiaryCreateModelToJson(DiaryCreateModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'babyId': instance.babyId,
      'daysAfterBirth': instance.daysAfterBirth,
      'likeCount': instance.likeCount,
      'date': instance.date.toIso8601String(),
      'sentences': instance.sentences,
      'files': instance.files,
    };
