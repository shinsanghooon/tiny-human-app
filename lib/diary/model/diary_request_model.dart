import 'package:json_annotation/json_annotation.dart';

import 'diary_picture_model.dart';
import 'diary_sentence_model.dart';

part 'diary_request_model.g.dart';

@JsonSerializable()
class DiaryRequestModel {
  final int userId;
  final int babyId;
  final int dayAfterBirth;
  final int likeCount;
  final String date;
  final List<DiarySentenceModel> sentences;
  final List<DiaryPictureModel> files;

  DiaryRequestModel(
      {required this.userId,
      required this.babyId,
      required this.dayAfterBirth,
      required this.likeCount,
      required this.date,
      required this.sentences,
      required this.files});

  factory DiaryRequestModel.fromJson(Map<String, dynamic> json)
  => _$DiaryRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryRequestModelToJson(this);
}
