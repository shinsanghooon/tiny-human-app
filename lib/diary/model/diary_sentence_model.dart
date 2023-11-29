import 'package:json_annotation/json_annotation.dart';

import '../../common/model/model_with_id.dart';

part 'diary_sentence_model.g.dart';

@JsonSerializable()
class DiarySentenceModel implements IModelWithId{
  @override
  final int id;
  final String sentence;

  DiarySentenceModel({
    required this.id,
    required this.sentence});

  factory DiarySentenceModel.fromJson(Map<String, dynamic> json) =>
      _$DiarySentenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiarySentenceModelToJson(this);
}
