import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../user/provider/auth_provider.dart';

final routeProvider = Provider<GoRouter>((ref) {
  // ref.watch -> 값이 변경될 때마다 다시 빌드
  // ref.read -> 한번만 읽고 값이 변경돼도 다시 빌드하지 않음
  // 실제로 authProvider는 변경될 일이 없음, 그래서 GoRouter의 상태는 동일
  final provider = ref.read(authProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});
