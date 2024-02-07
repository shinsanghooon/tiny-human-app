import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/album/model/album_model.dart';
import 'package:tiny_human_app/album/repository/album_repository.dart';

final albumProvider =
    StateNotifierProvider<AlbumStateNotifier, List<AlbumModel>>((ref) {
  final repo = ref.watch(albumRepositoryProvider);
  return AlbumStateNotifier(ref: ref, repository: repo);
});

class AlbumStateNotifier extends StateNotifier<List<AlbumModel>> {
  final Ref ref;
  final AlbumRepository repository;

  AlbumStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);
}
