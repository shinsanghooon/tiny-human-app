// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpchat_latest_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpChatLatestMessage _$HelpChatLatestMessageFromJson(
        Map<String, dynamic> json) =>
    HelpChatLatestMessage(
      helpRequestUserId: json['helpRequestUserId'] as int,
      helpAnswerUserId: json['helpAnswerUserId'] as int,
      message: json['message'] as String,
      messageTime: DateTime.parse(json['messageTime'] as String),
    );

Map<String, dynamic> _$HelpChatLatestMessageToJson(
        HelpChatLatestMessage instance) =>
    <String, dynamic>{
      'helpRequestUserId': instance.helpRequestUserId,
      'helpAnswerUserId': instance.helpAnswerUserId,
      'message': instance.message,
      'messageTime': DateConvertor.toIso8601String(instance.messageTime),
    };
