// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumCreateModel _$AlbumCreateModelFromJson(Map<String, dynamic> json) =>
    AlbumCreateModel(
      fileName: json['fileName'] as String,
      originalCreatedAt: json['originalCreatedAt'] == null
          ? null
          : DateTime.parse(json['originalCreatedAt'] as String),
      gpsLat: (json['gpsLat'] as num?)?.toDouble(),
      gpsLon: (json['gpsLon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AlbumCreateModelToJson(AlbumCreateModel instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'originalCreatedAt': instance.originalCreatedAt?.toIso8601String(),
      'gpsLat': instance.gpsLat,
      'gpsLon': instance.gpsLon,
    };
