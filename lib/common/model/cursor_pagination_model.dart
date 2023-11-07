import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase {}

class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({required this.message});
}

class CursorPaginationLoading extends CursorPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta nextCursorRequest;
  final List<T> body;

  CursorPagination({
    required this.nextCursorRequest,
    required this.body,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? nextCursorRequest,
    List<T>? body,
  }) {
    return CursorPagination<T>(
        nextCursorRequest: nextCursorRequest ?? this.nextCursorRequest, body: body ?? this.body);
  }

  factory CursorPagination.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int size;
  final int key;

  CursorPaginationMeta({
    required this.size,
    required this.key,
  });

  CursorPaginationMeta copyWith({int? size, int? key}) {
    return CursorPaginationMeta(
      size: size ?? this.size,
      key: key ?? this.key,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.nextCursorRequest,
    required super.body,
  });
}

class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.nextCursorRequest,
    required super.body,
  });
}
