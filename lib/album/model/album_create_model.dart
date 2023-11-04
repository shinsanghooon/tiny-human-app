import 'package:json_annotation/json_annotation.dart';

part 'album_create_model.g.dart';

@JsonSerializable()
class AlbumCreateModel {
  final String fileName;
  final DateTime originalCreatedAt;
  final double gpsLat;
  final double gpsLon;

  AlbumCreateModel(
      {required this.fileName,
      required this.originalCreatedAt,
      required this.gpsLat,
      required this.gpsLon});

  factory AlbumCreateModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumCreateModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumCreateModelToJson(this);
}
