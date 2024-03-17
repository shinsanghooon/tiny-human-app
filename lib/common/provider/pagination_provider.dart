import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_model.dart';
import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';
import 'package:tiny_human_app/common/model/model_with_id.dart';
import 'package:tiny_human_app/common/repository/base_pagination_repository.dart';

// PaginationProvider는 CursorPaginationBase의 상태를 관리하는 것이다.
class PaginationProvider<T extends IModelWithId, U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final int id;
  final U repository;
  final String order;

  PaginationProvider({
    required this.id,
    required this.repository,
    required this.order,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 50,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 가능성
      // State의 상태
      // 기본 상태는 CursorPaginationBase 이다.

      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 떄
      // 5) CursorPaginationFetchMore- 추가 데이터를 paginate 해오라는 요청을 받았을 때
      // 5가지를 클래스로 정의를 해두었다.

      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
      // 더 이상 페이지네이션을 실행할 필요가 없다.
      // 2) 로딩중
      //  - fetchMore가 true일 때, fetchMore는 스크롤 아래까지 가서 데이터를 더 가져와라 라고 할 때
      //  - fetchMore가 false일 때(데이터를 쭉 가져오고 있다가 위로 올라가서 새로고침을 할 때), 기존 요청은 중요하지 않기 때문에 멈추고 다시 페이지네이션

      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (pState.nextCursorRequest.key == -1) {
          // 데이터가 없는 상황
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      CursorPaginationParams cursorPaginationParams = CursorPaginationParams(size: fetchCount);

      if (fetchMore) {
        // 데이터를 추가로 가져오는 상황
        final pState = state as CursorPagination<T>;

        // 새로운 상태를 만든다.
        state = CursorPaginationFetchingMore<T>(
          nextCursorRequest: pState.nextCursorRequest,
          body: pState.body,
        );

        cursorPaginationParams = cursorPaginationParams.copyWith(
          key: pState.nextCursorRequest.key,
        );
      } else {
        // 데이터를 처음부터 가져오는 상황
        // 만약 기존 데이터가 있다면 기존 데이터를 보존한채로 Fetch 요청을 해야함
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(nextCursorRequest: pState.nextCursorRequest, body: pState.body);
        } else {
          // 데이터를 유지할 필요가 없는 상황
          state = CursorPaginationLoading();
        }
      }

      final response = await repository.paginateWithId(
        id: this.id,
        order: this.order, // fixed values until update something
        cursorPaginationParams: cursorPaginationParams,
      );

      if (state is CursorPaginationFetchingMore<T>) {
        final pState = state as CursorPaginationFetchingMore<T>;

        state = response.copyWith(
          body: [...pState.body, ...response.body],
        );
      } else {
        state = response;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
