import 'package:json_annotation/json_annotation.dart';

part 'user_push_create_model.g.dart';

@JsonSerializable()
class UserPushCreateModel {
  final String fcmToken;
  final String deviceInfo;

  UserPushCreateModel({
    required this.fcmToken,
    required this.deviceInfo,
  });

  factory UserPushCreateModel.fromJson(Map<String, dynamic> json) => _$UserPushCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPushCreateModelToJson(this);
}
