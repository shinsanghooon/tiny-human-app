// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryRequestModel _$DiaryRequestModelFromJson(Map<String, dynamic> json) =>
    DiaryRequestModel(
      userId: json['userId'] as int,
      babyId: json['babyId'] as int,
      dayAfterBirth: json['dayAfterBirth'] as int,
      likeCount: json['likeCount'] as int,
      date: json['date'] as String,
      sentences: (json['sentences'] as List<dynamic>)
          .map((e) => DiarySentenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (json['files'] as List<dynamic>)
          .map((e) => DiaryPictureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiaryRequestModelToJson(DiaryRequestModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'babyId': instance.babyId,
      'dayAfterBirth': instance.dayAfterBirth,
      'likeCount': instance.likeCount,
      'date': instance.date,
      'sentences': instance.sentences,
      'files': instance.files,
    };
