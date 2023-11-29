// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryResponseModel _$DiaryResponseModelFromJson(Map<String, dynamic> json) =>
    DiaryResponseModel(
      id: json['id'] as int,
      daysAfterBirth: json['daysAfterBirth'] as int,
      writer: json['writer'] as String,
      likeCount: json['likeCount'] as int,
      isDeleted: json['isDeleted'] as bool,
      date: DateTime.parse(json['date'] as String),
      sentences: (json['sentences'] as List<dynamic>)
          .map((e) => DiarySentenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pictures: (json['pictures'] as List<dynamic>)
          .map((e) => DiaryPictureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiaryResponseModelToJson(DiaryResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'daysAfterBirth': instance.daysAfterBirth,
      'writer': instance.writer,
      'likeCount': instance.likeCount,
      'isDeleted': instance.isDeleted,
      'date': instance.date.toIso8601String(),
      'sentences': instance.sentences,
      'pictures': instance.pictures,
    };
