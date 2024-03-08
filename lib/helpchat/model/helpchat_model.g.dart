// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpchat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpChatModel _$HelpChatModelFromJson(Map<String, dynamic> json) =>
    HelpChatModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      requestType: $enumDecode(_$ChatRequestTypeEnumMap, json['requestType']),
      contents: json['contents'] as String,
      createdAt: DateConvertor.stringToDateTime(json['createdAt'] as String?),
    );

Map<String, dynamic> _$HelpChatModelToJson(HelpChatModel instance) =>
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
