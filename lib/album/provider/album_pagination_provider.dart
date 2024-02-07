import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiny_human_app/album/model/album_delete_request_model.dart';
import 'package:tiny_human_app/album/model/album_response_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/provider/pagination_provider.dart';

import '../model/album_create_model.dart';
import '../model/album_model.dart';
import '../repository/album_pagination_repository.dart';

final albumPaginationProvider = StateNotifierProvider<AlbumPaginationStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(albumPaginationRepositoryProvider);
  int id = 1;
  String order = 'uploadedAt';
  return AlbumPaginationStateNotifier(babyId: id, order: order, repository: repo);
});

class AlbumPaginationStateNotifier extends PaginationProvider<AlbumResponseModel, AlbumPaginationRepository> {
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

  Future<List<AlbumModel>> addAlbums(int babyId, List<XFile> uploadImages) async {
    List<AlbumCreateModel> models = uploadImages.map((image) => AlbumCreateModel(fileName: image.name)).toList();
    // TODO 리턴값에 keyName 넣어줘서 state를 업데이트 할 수 있도록 변경
    return await repository.addAlbum(babyId: babyId, albums: models);
  }

  // TODO paginate force refatch 말고 state 변경
  void addAlbumsToState() {
    paginate(forceRefetch: true);
  }

  void deleteAlbums(int babyId, AlbumDeleteRequestModel model) async {
    await repository.deleteAlbums(babyId: babyId, model: model);

    final paginationState = state as CursorPagination;

    state = paginationState.copyWith(
        body: <AlbumResponseModel>[...paginationState.body.where((album) => !model.ids.contains(album.id)).toList()]);
  }
}
