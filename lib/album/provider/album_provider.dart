import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiny_human_app/album/model/album_create_model.dart';
import 'package:tiny_human_app/album/model/album_model.dart';
import 'package:tiny_human_app/album/repository/album_repository.dart';
import 'package:tiny_human_app/common/dio/dio.dart';

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

  Future<List<AlbumModel>> addAlbums(
      int babyId, List<XFile> uploadImages) async {
    List<AlbumCreateModel> models = uploadImages
        .map((image) => AlbumCreateModel(fileName: image.name))
        .toList();

    final response = await repository.addAlbum(babyId: babyId, albums: models);
    print(response.first.toString());

    final dio = ref.watch(dioProvider);
    for (int i = 0; i < uploadImages.length; i++) {
      String url = response[i].preSignedUrl;
      File file = File(uploadImages[i].path);
      var fileExt = file.path.split('.').last == 'jpg'
          ? 'jpeg'
          : file.path.split('.').last;
      await dio.put(url,
          data: file.openRead(),
          options: Options(
            headers: {
              Headers.contentLengthHeader: file.lengthSync(),
            },
            contentType: 'image/$fileExt',
          ));
    }

    return response;
  }
}
