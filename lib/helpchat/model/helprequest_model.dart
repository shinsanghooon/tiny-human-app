import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/helpchat/enum/chat_request_type.dart';

import '../../common/utils/date_convertor.dart';

part 'helprequest_model.g.dart';

@JsonSerializable()
class HelpRequestModel {
  final int id;
  final int userId;
  final ChatRequestType requestType;
  final String contents;
  @JsonKey(
    fromJson: DateConvertor.stringToDateTime,
  )
  final DateTime? createdAt;

  HelpRequestModel({
    required this.id,
    required this.userId,
    required this.requestType,
    required this.contents,
    this.createdAt,
  });

  factory HelpRequestModel.fromJson(Map<String, dynamic> json) => _$HelpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$HelpRequestModelToJson(this);
}
