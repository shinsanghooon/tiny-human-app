import 'package:tiny_human_app/common/model/cursor_pagination_params.dart';

import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {

  Future<CursorPagination<T>> paginateWithId({
    required int id,
    required String order,
    required CursorPaginationParams? cursorPaginationParams,
  });

  Future<T> getDetail({
    required int id,
  });
}
