import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/helpchat/enum/chat_request_type.dart';

import '../../common/utils/date_convertor.dart';

part 'helpchat_create_model.g.dart';

@JsonSerializable()
class HelpChatCreateModel {
  final int userId;
  final String requestType;
  final String contents;

  HelpChatCreateModel({required this.userId, required this.requestType, required this.contents});

  factory HelpChatCreateModel.fromJson(Map<String, dynamic> json) => _$HelpChatCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$HelpChatCreateModelToJson(this);
}
