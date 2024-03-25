import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/baby/provider/baby_provider.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/provider/pagination_provider.dart';
import 'package:tiny_human_app/diary/model/diary_file_model.dart';
import 'package:tiny_human_app/diary/model/diary_picture_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';
import 'package:tiny_human_app/diary/repository/diary_pagination_repository.dart';
import 'package:tiny_human_app/user/provider/user_me_provider.dart';

import '../model/date_request_model.dart';
import '../model/diary_create_model.dart';
import '../model/diary_response_with_presigned_model.dart';

final diaryDetailProvider = Provider.family<DiaryResponseModel?, int>((ref, id) {
  final state = ref.watch(diaryPaginationProvider);

  if (state is! CursorPagination) {
    return null;
  }
  return state.body.firstWhereOrNull((diary) => diary.id == id);
});

final diaryPaginationProvider = StateNotifierProvider<DiaryPaginationStateNotifier, CursorPaginationBase>((ref) {
  ref.watch(userMeProvider);
  print('diary-userme');
  final repo = ref.watch(diaryPaginationRepositoryProvider);
  final babyId = ref.watch(selectedBabyProvider);
  String order = 'uploadedAt';
  return DiaryPaginationStateNotifier(order: order, repository: repo, id: babyId);
});

class DiaryPaginationStateNotifier extends PaginationProvider<DiaryResponseModel, DiaryPaginationRepository> {
  final String order;

  DiaryPaginationStateNotifier({
    required this.order,
    required super.repository,
    required super.id,
  }) : super(order: order);

  // TODO 일기 페이지네이션 조회
  void getDiariesPagination({
    required int babyId, // babyId
    required String order,
    required CursorPaginationParams cursorPaginationParams,
  }) {}

  /// 페이지 새로고침
  void refreshPagination() async {
    await paginate(forceRefetch: true);
  }

  /// 일기 등록
  Future<DiaryResponseWithPresignedModel> addDiary(DiaryCreateModel model) async {
    final response = await repository.addDiary(model: model);

    DiaryResponseModel newDiary = DiaryResponseModel(
      id: id,
      daysAfterBirth: response.daysAfterBirth,
      writer: response.writer,
      likeCount: response.likeCount,
      isDeleted: false,
      date: response.date,
      sentences: response.sentences,
      pictures: response.pictures
          .map((picture) => DiaryPictureModel(
                id: picture.id,
                isMainPicture: picture.isMainPicture,
                contentType: picture.contentType,
                keyName: picture.keyName,
              ))
          .toList(),
    );

    final paginationState = state as CursorPagination;

    state = paginationState.copyWith(body: <DiaryResponseModel>[newDiary, ...paginationState.body]);

    return response;
  }

  /// 일기 삭제
  Future<void> deleteDiary({required int diaryId}) async {
    await repository.deleteDiary(diaryId: diaryId);

    if (state is! CursorPagination) {
      return;
    }
    final paginationState = state as CursorPagination;

    state = paginationState
        .copyWith(body: <DiaryResponseModel>[...paginationState.body.where((diary) => diary.id != diaryId).toList()]);
  }

  /// 일기 상세 조회
  void getDetail({required int id}) async {
    /// 만약 CursorPagination이 아니면 아무것도 없음 or 에러이니까
    /// paginate함수를 통해 초기화를 해준다.
    if (state is! CursorPagination) {
      await paginate(fetchCount: 20);
    }

    /// 초기화를 시도했는데도 문제가 발생하면 빈값을 리턴해준다.
    if (state is! CursorPagination) {
      return;
    }

    /// state를 CursorPagination으로 캐스팅해준다.
    final paginationState = state as CursorPagination;
    final response = await repository.getDetail(id: id);

    if (paginationState.body.where((diary) => diary.id == id).isEmpty) {
      // 데이터가 없을 때는 캐시의 끝에다가 데이터를 추가해도 된다.
      state = paginationState.copyWith(body: <DiaryResponseModel>[
        ...paginationState.body,
        response,
      ]);
    } else {
      // pState에 있는 데이터를 루핑하면서 id가 같은 데이터를 변경해준다.
      // [model(1), model(2), model(3)]
      // id: 2인 친구를 Detail 모델을 가져와라
      // getDetail(id: 2)
      // [model(1), detailModel(2), model(3)]
      state = paginationState.copyWith(
        body: paginationState.body.map<DiaryResponseModel>((diary) => diary.id == id ? response : diary).toList(),
      );
    }
  }

  Future<DiaryResponseModel> updateSentence(
      {required int diaryId, required int sentenceId, required SentenceRequestModel model}) async {
    final response = await repository.updateSentence(diaryId: diaryId, sentenceId: sentenceId, model: model);

    final paginationState = state as CursorPagination;

    state = paginationState.copyWith(body: <DiaryResponseModel>[
      ...paginationState.body.map((diary) => diary.id == diaryId ? response : diary).toList()
    ]);

    return response;
  }

  Future<DiaryResponseModel> updateDate({required int diaryId, required DateRequestModel model}) async {
    final response = await repository.updateDate(diaryId: diaryId, model: model);

    final paginationState = state as CursorPagination;

    state = paginationState.copyWith(body: <DiaryResponseModel>[
      ...paginationState.body.map((diary) => diary.id == diaryId ? response : diary).toList()
    ]);

    return response;
  }

  Future<void> deleteImages({required int diaryId, required int imageId}) async {
    await repository.deleteImages(diaryId: diaryId, imageId: imageId);

    final paginationState = state as CursorPagination;

    state = paginationState
        .copyWith(body: <DiaryResponseModel>[...paginationState.body.where((diary) => diary.id != diaryId).toList()]);
  }

  Future<DiaryResponseWithPresignedModel> addImages(
      {required int diaryId, required List<DiaryFileModel> diaryFileModels}) async {
    final response = await repository.addImages(diaryId: diaryId, models: diaryFileModels);

    // TODO: state만 변경
    paginate(forceRefetch: true);

    return response;
  }
}
