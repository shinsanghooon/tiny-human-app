// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpchat_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpChatCreateModel _$HelpChatCreateModelFromJson(Map<String, dynamic> json) =>
    HelpChatCreateModel(
      helpRequestId: json['helpRequestId'] as int,
      helpRequestUserId: json['helpRequestUserId'] as int,
      helpAnswerUserId: json['helpAnswerUserId'] as int,
    );

Map<String, dynamic> _$HelpChatCreateModelToJson(
        HelpChatCreateModel instance) =>
    <String, dynamic>{
      'helpRequestId': instance.helpRequestId,
      'helpRequestUserId': instance.helpRequestUserId,
      'helpAnswerUserId': instance.helpAnswerUserId,
    };
