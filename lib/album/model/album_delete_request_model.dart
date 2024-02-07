import 'package:json_annotation/json_annotation.dart';

part 'album_delete_request_model.g.dart';

@JsonSerializable()
class AlbumDeleteRequestModel {
  final List<int> ids;

  AlbumDeleteRequestModel({required this.ids});

  factory AlbumDeleteRequestModel.fromJson(Map<String, dynamic> json)
  => _$AlbumDeleteRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumDeleteRequestModelToJson(this);
}
