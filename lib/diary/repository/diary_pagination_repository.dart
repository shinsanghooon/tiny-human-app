import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/common/dio/dio.dart';
import 'package:tiny_human_app/common/repository/base_pagination_repository.dart';
import 'package:tiny_human_app/diary/model/diary_create_model.dart';
import 'package:tiny_human_app/diary/model/diary_file_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';

import '../../common/constant/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/cursor_pagination_params.dart';
import '../model/date_request_model.dart';
import '../model/diary_response_with_presigned_model.dart';

part 'diary_pagination_repository.g.dart';

final diaryPaginationRepositoryProvider = Provider<DiaryPaginationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DiaryPaginationRepository(dio, baseUrl: "http://$ip/api/v1/diaries");
});

@RestApi()
abstract class DiaryPaginationRepository implements IBasePaginationRepository<DiaryResponseModel> {
  factory DiaryPaginationRepository(Dio dio, {String baseUrl}) = _DiaryPaginationRepository;

  /// 일기를 등록합니다.
  @POST('')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseWithPresignedModel> addDiary({@Body() required DiaryCreateModel model});

  /// 일기 리스트를 요청합니다.
  /// 페이지네이션 응답을 리턴합니다.
  @GET('/babies/{babyId}')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<DiaryResponseModel>> paginateWithId({
    @Path('babyId') required int id,
    @Query("order") required String order,
    @Queries() CursorPaginationParams? cursorPaginationParams,
  });

  /// 일기를 삭제합니다.
  @DELETE('/{diaryId}')
  @Headers({'accessToken': 'true'})
  Future<void> deleteDiary({@Path('diaryId') required int diaryId});

  /// 일기 상세 정보를 요청합니다.
  @GET('/{diaryId}')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseModel> getDetail({@Path('diaryId') required int id});

  /// 일기 내용을 변경합니다.
  @PATCH('/{diaryId}/sentences/{sentenceId}')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseModel> updateSentence(
      {@Path('diaryId') required int diaryId,
      @Path('sentenceId') required int sentenceId,
      @Body() required SentenceRequestModel model});

  /// 일기 작성 일자를 변경합니다.
  @PATCH('/{diaryId}/date')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseModel> updateDate(
      {@Path('diaryId') required int diaryId, @Body() required DateRequestModel model});

  /// 사진을 삭제합니다.
  @DELETE('/{diaryId}/pictures/{deletedImageId}')
  @Headers({'accessToken': 'true'})
  Future<void> deleteImages({
    @Path('diaryId') required int diaryId,
    @Path('deletedImageId') required int imageId,
  });

  /// 사진을 등록합니다.
  @POST('/{diaryId}/pictures')
  @Headers({'accessToken': 'true'})
  Future<DiaryResponseWithPresignedModel> addImages(
      {@Path('diaryId') required int diaryId, @Body() required List<DiaryFileModel> models});
}
