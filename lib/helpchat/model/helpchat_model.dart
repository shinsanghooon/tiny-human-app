import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/date_convertor.dart';
import 'helprequest_model.dart';

part 'helpchat_model.g.dart';

@JsonSerializable()
class HelpChatModel {
  final int id;
  final int helpRequestId;
  final int helpRequestUserId;
  final int helpAnswerUserId;
  final String? latestMessage;
  @JsonKey(
    fromJson: DateConvertor.stringToDateTime,
  )
  final DateTime? latestMessageTime;
  @JsonKey(
    fromJson: DateConvertor.stringToDateTime,
  )
  final DateTime? createdAt;
  final HelpRequestModel? helpRequest;

  HelpChatModel({
    required this.id,
    required this.helpRequestId,
    required this.helpRequestUserId,
    required this.helpAnswerUserId,
    this.latestMessage,
    this.latestMessageTime,
    this.createdAt,
    this.helpRequest,
  });

  factory HelpChatModel.fromJson(Map<String, dynamic> json) => _$HelpChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$HelpChatModelToJson(this);
}
