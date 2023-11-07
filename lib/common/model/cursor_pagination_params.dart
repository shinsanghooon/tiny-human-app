import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_params.g.dart';

@JsonSerializable()
class CursorPaginationParams {
  final int? key;
  final int? size;

  const CursorPaginationParams({
    this.key, this.size,
  });

  CursorPaginationParams copyWith({
    int? key,
    int? size
  }) {
    return CursorPaginationParams(
      key: key ?? this.key,
      size: size ?? this.size,
    );
  }

  factory CursorPaginationParams.fromJson(Map<String, dynamic> json)
  => _$CursorPaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CursorPaginationParamsToJson(this);
}
