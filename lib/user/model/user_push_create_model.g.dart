// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_push_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPushCreateModel _$UserPushCreateModelFromJson(Map<String, dynamic> json) =>
    UserPushCreateModel(
      fcmToken: json['fcmToken'] as String,
      deviceInfo: json['deviceInfo'] as String,
    );

Map<String, dynamic> _$UserPushCreateModelToJson(
        UserPushCreateModel instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
      'deviceInfo': instance.deviceInfo,
    };
