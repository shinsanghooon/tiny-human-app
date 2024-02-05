import 'package:json_annotation/json_annotation.dart';

part 'date_request_model.g.dart';

@JsonSerializable()
class DateRequestModel {
  final DateTime updatedDate;

  DateRequestModel({required this.updatedDate});

  factory DateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$DateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DateRequestModelToJson(this);
}
