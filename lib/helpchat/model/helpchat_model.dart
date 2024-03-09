import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/date_convertor.dart';

part 'helpchat_model.g.dart';

@JsonSerializable()
class HelpChatModel {
  final int id;
  final int helpRequestId;
  final int helpRequestUserId;
  final int helpAnswerUserId;
  @JsonKey(
    fromJson: DateConvertor.stringToDateTime,
  )
  final DateTime? createdAt;

  HelpChatModel({
    required this.id,
    required this.helpRequestId,
    required this.helpRequestUserId,
    required this.helpAnswerUserId,
    this.createdAt,
  });

  factory HelpChatModel.fromJson(Map<String, dynamic> json) => _$HelpChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$HelpChatModelToJson(this);
}
