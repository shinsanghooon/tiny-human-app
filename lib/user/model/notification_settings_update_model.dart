import 'package:json_annotation/json_annotation.dart';

part 'notification_settings_update_model.g.dart';

@JsonSerializable()
class NotificationSettingsUpdates {
  final bool isAllowChatNotifications;
  final bool isAllowDiaryNotifications;

  NotificationSettingsUpdates({
    required this.isAllowChatNotifications,
    required this.isAllowDiaryNotifications,
  });

  factory NotificationSettingsUpdates.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsUpdatesFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsUpdatesToJson(this);
}
