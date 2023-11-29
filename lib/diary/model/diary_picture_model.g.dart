// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_picture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryPictureModel _$DiaryPictureModelFromJson(Map<String, dynamic> json) =>
    DiaryPictureModel(
      id: json['id'] as int,
      isMainPicture: json['isMainPicture'] as bool,
      contentType: $enumDecode(_$FileTypeEnumMap, json['contentType']),
      keyName: json['keyName'] as String,
    );

Map<String, dynamic> _$DiaryPictureModelToJson(DiaryPictureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isMainPicture': instance.isMainPicture,
      'contentType': _$FileTypeEnumMap[instance.contentType]!,
      'keyName': instance.keyName,
    };

const _$FileTypeEnumMap = {
  FileType.PHOTO: 'PHOTO',
  FileType.VIDEO: 'VIDEO',
};
