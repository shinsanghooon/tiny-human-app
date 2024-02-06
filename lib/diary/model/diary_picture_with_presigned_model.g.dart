// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_picture_with_presigned_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryPictureWithPresignedModel _$DiaryPictureWithPresignedModelFromJson(
        Map<String, dynamic> json) =>
    DiaryPictureWithPresignedModel(
      id: json['id'] as int,
      isMainPicture: json['isMainPicture'] as bool,
      contentType: $enumDecode(_$FileTypeEnumMap, json['contentType']),
      fileName: json['fileName'] as String,
      keyName: json['keyName'] as String,
      preSignedUrl: json['preSignedUrl'] as String,
    );

Map<String, dynamic> _$DiaryPictureWithPresignedModelToJson(
        DiaryPictureWithPresignedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isMainPicture': instance.isMainPicture,
      'contentType': _$FileTypeEnumMap[instance.contentType]!,
      'fileName': instance.fileName,
      'keyName': instance.keyName,
      'preSignedUrl': instance.preSignedUrl,
    };

const _$FileTypeEnumMap = {
  FileType.PHOTO: 'PHOTO',
  FileType.VIDEO: 'VIDEO',
};
