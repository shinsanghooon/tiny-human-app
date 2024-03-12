// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpchat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpChatModel _$HelpChatModelFromJson(Map<String, dynamic> json) =>
    HelpChatModel(
      id: json['id'] as int,
      helpRequestId: json['helpRequestId'] as int,
      helpRequestUserId: json['helpRequestUserId'] as int,
      helpAnswerUserId: json['helpAnswerUserId'] as int,
      createdAt: DateConvertor.stringToDateTime(json['createdAt'] as String?),
      helpRequest: json['helpRequest'] == null
          ? null
          : HelpRequestModel.fromJson(
              json['helpRequest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HelpChatModelToJson(HelpChatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'helpRequestId': instance.helpRequestId,
      'helpRequestUserId': instance.helpRequestUserId,
      'helpAnswerUserId': instance.helpAnswerUserId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'helpRequest': instance.helpRequest,
    };
