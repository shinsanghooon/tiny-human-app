import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/common/dio/dio.dart';
import 'package:tiny_human_app/common/repository/base_pagination_repository.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';

import '../../common/constant/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/cursor_pagination_params.dart';
import '../model/date_request_model.dart';

part 'diary_pagination_repository.g.dart';

final diaryPaginationRepositoryProvider =
    Provider<DiaryPaginationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DiaryPaginationRepository(dio, baseUrl: "http://$ip/api/v1/diaries");
});

@RestApi()
abstract class DiaryPaginationRepository
    implements IBasePaginationRepository<DiaryResponseModel> {
  factory DiaryPaginationRepository(Dio dio, {String baseUrl}) =
      _DiaryPaginationRepository;

  @GET('/babies/{babyId}')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<DiaryResponseModel>> paginateWithId({
    @Path('babyId') required int id,
    @Query("order") required String order,
    @Queries() CursorPaginationParams? cursorPaginationParams,
  });

  @GET('/{diaryId}')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseModel> getDetail({@Path('diaryId') required int id});

  @PATCH('/{diaryId}/sentences/{sentenceId}')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseModel> updateSentence(
      {@Path('diaryId') required int diaryId,
      @Path('sentenceId') required int sentenceId,
      @Body() required SentenceRequestModel model});

  @PATCH('/{diaryId}/date')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseModel> updateDate(
      {@Path('diaryId') required int diaryId,
      @Body() required DateRequestModel model});
}
