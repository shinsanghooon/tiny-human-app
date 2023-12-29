import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/baby/model/baby_model.dart';

part 'baby_model_with_presigned.g.dart';

@JsonSerializable()
class BabyModelWithPreSigned extends BabyModel {
  final String preSignedUrl;

  BabyModelWithPreSigned({
    required super.id,
    required super.name,
    required super.gender,
    required super.dayOfBirth,
    required super.timeOfBirth,
    required super.nickName,
    required super.profileImgKeyName,
    required super.description,
    required this.preSignedUrl,
  });

  factory BabyModelWithPreSigned.fromJson(Map<String, dynamic> json) =>
      _$BabyModelWithPreSignedFromJson(json);
}
