import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';

import 'diary_file_model.dart';

part 'diary_create_model.g.dart';

@JsonSerializable()
class DiaryCreateModel {
  final int userId;
  final int babyId;
  final int daysAfterBirth;
  final int likeCount;
  final DateTime date;
  final List<SentenceRequestModel> sentences;
  final List<DiaryFileModel> files;

  DiaryCreateModel(
      {required this.userId,
      required this.babyId,
      required this.daysAfterBirth,
      required this.likeCount,
      required this.date,
      required this.sentences,
      required this.files});

  factory DiaryCreateModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryCreateModelToJson(this);
}
