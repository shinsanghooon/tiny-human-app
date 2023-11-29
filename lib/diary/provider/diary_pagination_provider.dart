import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/provider/pagination_provider.dart';
import 'package:tiny_human_app/diary/model/diary_request_model.dart';
import 'package:tiny_human_app/diary/model/diary_response_model.dart';
import 'package:tiny_human_app/diary/repository/diary_pagination_repository.dart';

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
}

