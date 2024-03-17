import 'package:json_annotation/json_annotation.dart';

part 'user_push_response.g.dart';

@JsonSerializable()
class UserPushResponse {
  final int id;
  final int userId;
  final String fcmToken;
  final String deviceInfo;

  UserPushResponse({
    required this.id,
    required this.userId,
    required this.fcmToken,
    required this.deviceInfo,
  });

  factory UserPushResponse.fromJson(Map<String, dynamic> json) => _$UserPushResponseFromJson(json);
}
