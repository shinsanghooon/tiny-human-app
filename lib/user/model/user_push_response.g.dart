// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_push_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPushResponse _$UserPushResponseFromJson(Map<String, dynamic> json) =>
    UserPushResponse(
      id: json['id'] as int,
      userId: json['userId'] as int,
      fcmToken: json['fcmToken'] as String,
      deviceInfo: json['deviceInfo'] as String,
    );

Map<String, dynamic> _$UserPushResponseToJson(UserPushResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fcmToken': instance.fcmToken,
      'deviceInfo': instance.deviceInfo,
    };
