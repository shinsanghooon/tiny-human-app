import 'package:json_annotation/json_annotation.dart';

part 'diary_model.g.dart';

@JsonSerializable()
class DiaryModel {
  final String sentence;

  DiaryModel({required this.sentence});

  factory DiaryModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryModelToJson(this);
}
