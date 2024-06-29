import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final int id;
  final String name;
  final String email;
  final String status;
  final String? lastLoginAt;
  final bool isAllowChatNotifications;
  final bool isAllowDiaryNotifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    this.lastLoginAt,
    required this.isAllowChatNotifications,
    required this.isAllowDiaryNotifications,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
