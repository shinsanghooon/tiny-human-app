import 'package:flutter/cupertino.dart';
import 'package:tiny_human_app/common/provider/pagination_provider.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      print('fetch more!');
      provider.paginate(fetchMore: true);
    }
  }
}
