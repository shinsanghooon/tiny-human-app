import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/provider/pagination_provider.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/model/sentence_request_model.dart';
import 'package:tiny_human_app/diary/repository/diary_pagination_repository.dart';

import '../model/date_request_model.dart';

final diaryDetailProvider =
    Provider.family<DiaryResponseModel?, int>((ref, id) {
  final state = ref.watch(diaryPaginationProvider);

  if (state is! CursorPagination) {
    return null;
  }
  return state.body.firstWhereOrNull((diary) => diary.id == id);
});

final diaryPaginationProvider =
    StateNotifierProvider<DiaryPaginationStateNotifier, CursorPaginationBase>(
        (ref) {
  final repo = ref.watch(diaryPaginationRepositoryProvider);
  int id = 1;
  String order = 'uploadedAt';
  return DiaryPaginationStateNotifier(
      babyId: id, order: order, repository: repo);
});

class DiaryPaginationStateNotifier
    extends PaginationProvider<DiaryResponseModel, DiaryPaginationRepository> {
  final int babyId;
  final String order;

  DiaryPaginationStateNotifier({
    required this.babyId,
    required this.order,
    required super.repository,
  });

  void getDiaries({
    required int id, // babyId
    required String order,
    required CursorPaginationParams cursorPaginationParams,
  }) {}

  void addDiary() {
    paginate(forceRefetch: true);
  }

  void getDetail({required int id}) async {
    print('diary pagination state notifier - getDetail');

    // 만약 CursorPagination이 아니면 아무것도 없음 or 에러이니까
    // paginate함수를 통해 초기화를 해준다.
    if (state is! CursorPagination) {
      await paginate(fetchCount: 20);
    }

    // 초기화를 시도했는데도 문제가 발생하면 빈값을 리턴해준다.
    if (state is! CursorPagination) {
      return;
    }

    // state를 CursorPagination으로 캐스팅해준다.
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
        body: paginationState.body
            .map<DiaryResponseModel>(
                (diary) => diary.id == id ? response : diary)
            .toList(),
      );
    }
  }

  void deleteDetail({required int id}) {
    if (state is! CursorPagination) {
      return;
    }
    final paginationState = state as CursorPagination;

    state = paginationState.copyWith(body: <DiaryResponseModel>[
      ...paginationState.body.where((diary) => diary.id != id).toList()
    ]);
  }

  Future<DiaryResponseModel> updateSentence(
      {required int diaryId,
      required int sentenceId,
      required SentenceRequestModel model}) {
    final response = repository.updateSentence(
        diaryId: diaryId, sentenceId: sentenceId, model: model);

    // TODO: state update
    return response;
  }

  Future<DiaryResponseModel> updateDate(
      {required int diaryId, required DateRequestModel model}) {
    final response = repository.updateDate(diaryId: diaryId, model: model);

    // TODO: state update
    return response;
  }
}
