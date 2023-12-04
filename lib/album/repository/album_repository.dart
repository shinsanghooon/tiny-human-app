import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/album/model/album_create_model.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/dio/dio.dart';

import '../model/album_model.dart';

part 'album_repository.g.dart';

final albumRepositoryProvider = Provider<AlbumRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AlbumRepository(dio, baseUrl: "http://$ip/api/v1/babies");
});

@RestApi()
abstract class AlbumRepository {
  // baseUrl: api/v1/babies
  factory AlbumRepository(Dio dio, {String baseUrl}) = _AlbumRepository;

  @POST('/{babyId}/albums')
  @Headers({'accessToken': 'true'})
  Future<List<AlbumModel>> addAlbum({
    @Path() required int babyId,
    @Body() required List<AlbumCreateModel> albums,
  });
}
