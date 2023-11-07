
import 'package:json_annotation/json_annotation.dart';
import 'package:tiny_human_app/common/model/model_with_id.dart';

import '../../common/utils/data_utils.dart';

part 'album_response_model.g.dart';

@JsonSerializable()
class AlbumResponseModel implements IModelWithId{
  @override
  final int id;
  final int babyId;
  final String contentType;
  final String keyName;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
    includeIfNull: false,
  )
  final DateTime? originalCreatedAt;

  AlbumResponseModel({
    required this.id,
    required this.babyId,
    required this.contentType,
    required this.keyName,
    this.originalCreatedAt,
  });

  factory AlbumResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumResponseModelFromJson(json);
}
