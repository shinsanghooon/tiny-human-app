import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/diary/model/diary_picture_with_presigned_model.dart';

import '../../common/model/model_with_id.dart';
import 'diary_sentence_model.dart';

part 'diary_response_with_presigned_model.g.dart';

@JsonSerializable()
class DiaryResponseWithPresignedModel implements IModelWithId {
  @override
  final int id;
  final int daysAfterBirth;
  final String writer;
  final int likeCount;
  final bool isDeleted;
  final DateTime date;
  final List<DiarySentenceModel> sentences;
  final List<DiaryPictureWithPresignedModel> pictures;

  DiaryResponseWithPresignedModel({
    required this.id,
    required this.daysAfterBirth,
    required this.writer,
    required this.likeCount,
    required this.isDeleted,
    required this.date,
    required this.sentences,
    required this.pictures,
  });

  factory DiaryResponseWithPresignedModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryResponseWithPresignedModelFromJson(json);
}
