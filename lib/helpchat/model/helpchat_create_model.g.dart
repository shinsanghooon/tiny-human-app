// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpchat_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpChatCreateModel _$HelpChatCreateModelFromJson(Map<String, dynamic> json) =>
    HelpChatCreateModel(
      userId: json['userId'] as int,
      requestType: json['requestType'] as String,
      contents: json['contents'] as String,
    );

Map<String, dynamic> _$HelpChatCreateModelToJson(
        HelpChatCreateModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'requestType': instance.requestType,
      'contents': instance.contents,
    };
