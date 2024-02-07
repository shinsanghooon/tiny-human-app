// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_delete_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumDeleteRequestModel _$AlbumDeleteRequestModelFromJson(
        Map<String, dynamic> json) =>
    AlbumDeleteRequestModel(
      ids: (json['ids'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$AlbumDeleteRequestModelToJson(
        AlbumDeleteRequestModel instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };
