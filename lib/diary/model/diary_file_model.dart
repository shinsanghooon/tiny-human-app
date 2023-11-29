import 'package:json_annotation/json_annotation.dart';

part 'diary_file_model.g.dart';

@JsonSerializable()
class DiaryFileModel {
  final String fileName;

  DiaryFileModel({required this.fileName});

  factory DiaryFileModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryFileModelToJson(this);
}
