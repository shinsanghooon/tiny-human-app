// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      lastLoginAt: json['lastLoginAt'] as String?,
      isAllowChatNotifications: json['isAllowChatNotifications'] as bool,
      isAllowDiaryNotifications: json['isAllowDiaryNotifications'] as bool,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'status': instance.status,
      'lastLoginAt': instance.lastLoginAt,
      'isAllowChatNotifications': instance.isAllowChatNotifications,
      'isAllowDiaryNotifications': instance.isAllowDiaryNotifications,
    };
