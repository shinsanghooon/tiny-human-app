// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettingsUpdates _$NotificationSettingsUpdatesFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsUpdates(
      isAllowChatNotifications: json['isAllowChatNotifications'] as bool,
      isAllowDiaryNotifications: json['isAllowDiaryNotifications'] as bool,
    );

Map<String, dynamic> _$NotificationSettingsUpdatesToJson(
        NotificationSettingsUpdates instance) =>
    <String, dynamic>{
      'isAllowChatNotifications': instance.isAllowChatNotifications,
      'isAllowDiaryNotifications': instance.isAllowDiaryNotifications,
    };
