import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';

part 'helpchat_latest_message.g.dart';

@JsonSerializable()
class HelpChatLatestMessage {
  final int helpRequestUserId;
  final int helpAnswerUserId;
  final String message;
  @JsonKey(toJson: DateConvertor.toIso8601String)
  final DateTime messageTime;

  HelpChatLatestMessage({
    required this.helpRequestUserId,
    required this.helpAnswerUserId,
    required this.message,
    required this.messageTime,
  });

  Map<String, dynamic> toJson() => _$HelpChatLatestMessageToJson(this);
}
