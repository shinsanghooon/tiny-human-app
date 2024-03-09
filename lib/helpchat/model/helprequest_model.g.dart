// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helprequest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpRequestModel _$HelpRequestModelFromJson(Map<String, dynamic> json) =>
    HelpRequestModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      requestType: $enumDecode(_$ChatRequestTypeEnumMap, json['requestType']),
      contents: json['contents'] as String,
      createdAt: DateConvertor.stringToDateTime(json['createdAt'] as String?),
    );

Map<String, dynamic> _$HelpRequestModelToJson(HelpRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'requestType': _$ChatRequestTypeEnumMap[instance.requestType]!,
      'contents': instance.contents,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ChatRequestTypeEnumMap = {
  ChatRequestType.KEYWORD: 'KEYWORD',
  ChatRequestType.LOCATION: 'LOCATION',
};
