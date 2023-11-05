import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_utils.dart';

part 'album_model.g.dart';

@JsonSerializable()
class AlbumModel {
  // Long id, Long babyId, ContentType contentType, String keyName, LocalDateTime originalCreatedAt
  final int id;
  final int babyId;
  final String contentType;
  final String filename;
  final String preSignedUrl;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
    includeIfNull: false,
  )
  final DateTime? originalCreatedAt;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime createdAt;

  AlbumModel({
    required this.id,
    required this.babyId,
    required this.contentType,
    required this.filename,
    required this.preSignedUrl,
    this.originalCreatedAt,
    required this.createdAt,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  @override
  String toString() {
    return 'AlbumModel{id: $id, babyId: $babyId, contentType: $contentType, filename: $filename, preSignedUrl: $preSignedUrl, originalCreatedAt: $originalCreatedAt, createdAt: $createdAt}';
  }
}
