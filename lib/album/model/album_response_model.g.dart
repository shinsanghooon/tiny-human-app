// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumResponseModel _$AlbumResponseModelFromJson(Map<String, dynamic> json) =>
    AlbumResponseModel(
      id: json['id'] as int,
      babyId: json['babyId'] as int,
      contentType: json['contentType'] as String,
      keyName: json['keyName'] as String,
      originalCreatedAt:
          DateConvertor.stringToDateTime(json['originalCreatedAt'] as String?),
    );

Map<String, dynamic> _$AlbumResponseModelToJson(AlbumResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'babyId': instance.babyId,
      'contentType': instance.contentType,
      'keyName': instance.keyName,
      'originalCreatedAt': instance.originalCreatedAt?.toIso8601String(),
    };
