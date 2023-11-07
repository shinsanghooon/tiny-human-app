import 'dart:ffi';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/album/model/album_create_model.dart';
import 'package:tiny_human_app/album/model/album_response_model.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/dio/dio.dart';
import 'package:tiny_human_app/common/repository/base_pagination_repository.dart';

import '../model/album_model.dart';

part 'album_pagination_repository.g.dart';

final albumPaginationRepositoryProvider =
    Provider<AlbumPaginationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AlbumPaginationRepository(dio, baseUrl: "http://$ip/api/v1/babies");
});

@RestApi()
abstract class AlbumPaginationRepository
    implements IBasePaginationRepository<AlbumResponseModel> {
  // baseUrl: api/v1/babies
  factory AlbumPaginationRepository(Dio dio, {String baseUrl}) =
      _AlbumPaginationRepository;

  @GET('/{babyId}/albums')
  @Headers({'accessToken': 'true', 'Content-Type': 'application/json'})
  Future<CursorPagination<AlbumResponseModel>> paginateWithId({
    @Path('babyId') required int id,
    @Query("order") required String order,
    @Body() CursorPaginationParams? cursorPaginationParams,
  });
}
