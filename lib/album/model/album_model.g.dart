// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel(
      id: json['id'] as int,
      babyId: json['babyId'] as int,
      contentType: json['contentType'] as String,
      filename: json['filename'] as String,
      preSignedUrl: json['preSignedUrl'] as String,
      originalCreatedAt: DateConvertor.stringToDateTime(json['originalCreatedAt'] as String?),
      createdAt: DateConvertor.stringToDateTime(json['createdAt'] as String?),
    );

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) => <String, dynamic>{
      'id': instance.id,
      'babyId': instance.babyId,
      'contentType': instance.contentType,
      'filename': instance.filename,
      'preSignedUrl': instance.preSignedUrl,
      'originalCreatedAt': instance.originalCreatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
