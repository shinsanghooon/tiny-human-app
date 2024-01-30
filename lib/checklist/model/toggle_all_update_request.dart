import 'package:json_annotation/json_annotation.dart';

part 'toggle_all_update_request.g.dart';

@JsonSerializable()
class ToggleAllUpdateRequest {
  final bool targetChecked;

  ToggleAllUpdateRequest({required this.targetChecked});

  factory ToggleAllUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ToggleAllUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ToggleAllUpdateRequestToJson(this);
}
