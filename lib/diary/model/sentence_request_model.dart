import 'package:json_annotation/json_annotation.dart';

import '../../common/model/model_with_id.dart';

part 'sentence_request_model.g.dart';

@JsonSerializable()
class SentenceRequestModel{

  final String sentence;

  SentenceRequestModel({
    required this.sentence});

  factory SentenceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SentenceRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SentenceRequestModelToJson(this);
}
