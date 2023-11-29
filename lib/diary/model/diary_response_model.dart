
import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/common/model/model_with_id.dart';
import 'package:tiny_human_app/common/utils/data_utils.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_sentence_model.dart';

part 'diary_response_model.g.dart';

@JsonSerializable()
class DiaryResponseModel implements IModelWithId {
  @override
  final int id;
  final int daysAfterBirth;
  final String writer;
  final int likeCount;
  final bool isDeleted;
  final DateTime date;
  final List<DiarySentenceModel> sentences;
  final List<DiaryPictureModel> pictures;

  DiaryResponseModel({
    required this.id,
    required this.daysAfterBirth,
    required this.writer,
    required this.likeCount,
    required this.isDeleted,
    required this.date,
    required this.sentences,
    required this.pictures,
  });

  factory DiaryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DiaryResponseModelFromJson(json);
}
