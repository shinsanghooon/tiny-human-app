import 'package:json_annotation/json_annotation.dart';

part 'helpchat_create_model.g.dart';

@JsonSerializable()
class HelpChatCreateModel {
  final int helpRequestId;
  final int helpRequestUserId;
  final int helpAnswerUserId;

  HelpChatCreateModel({
    required this.helpRequestId,
    required this.helpRequestUserId,
    required this.helpAnswerUserId,
  });

  factory HelpChatCreateModel.fromJson(Map<String, dynamic> json) => _$HelpChatCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$HelpChatCreateModelToJson(this);
}
