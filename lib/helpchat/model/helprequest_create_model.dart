import 'package:json_annotation/json_annotation.dart';

part 'helprequest_create_model.g.dart';

@JsonSerializable()
class HelpRequestCreateModel {
  final int userId;
  final String requestType;
  final String contents;

  HelpRequestCreateModel({required this.userId, required this.requestType, required this.contents});

  factory HelpRequestCreateModel.fromJson(Map<String, dynamic> json) => _$HelpRequestCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$HelpRequestCreateModelToJson(this);
}
