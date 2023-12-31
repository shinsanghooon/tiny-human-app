import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/album/model/album_response_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/provider/pagination_provider.dart';

import '../repository/album_pagination_repository.dart';

final albumPaginationProvider =
    StateNotifierProvider<AlbumPaginationStateNotifier, CursorPaginationBase>(
        (ref) {
  final repo = ref.watch(albumPaginationRepositoryProvider);
  int id = 1;
  String order = 'uploadedAt';
  return AlbumPaginationStateNotifier(
      babyId: id, order: order, repository: repo);
});

class AlbumPaginationStateNotifier
    extends PaginationProvider<AlbumResponseModel, AlbumPaginationRepository> {
  final int babyId;
  final String order;

  AlbumPaginationStateNotifier({
    required this.babyId,
    required this.order,
    required super.repository,
  }) : super();

  void getAlbums({
    required int id,
    required String order,
    required CursorPaginationParams cursorPaginationParams,
  }) {}

  void addAlbums() {
    paginate(forceRefetch: true);
  }
}
