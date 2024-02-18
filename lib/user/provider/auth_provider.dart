import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/album/view/album_screen.dart';
import 'package:tiny_human_app/baby/view/baby_screen.dart';
import 'package:tiny_human_app/common/view/root_screen.dart';
import 'package:tiny_human_app/common/view/splash_screen.dart';
import 'package:tiny_human_app/diary/view/diary_screen.dart';
import 'package:tiny_human_app/helpchat/view/helpchat_screen.dart';
import 'package:tiny_human_app/user/provider/user_me_provider.dart';
import 'package:tiny_human_app/user/view/login_screen.dart';

import '../model/user_model.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      // UserModel에 변경이 생겼을 때만 AuthProvider에 변경사항을 알려준다.
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: BabyScreen.routeName,
          builder: (_, __) => const BabyScreen(),
        ),
        GoRoute(
          path: '/home',
          name: RootScreen.routeName,
          builder: (_, __) => const RootScreen(),
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/diary',
          name: DiaryScreen.routeName,
          builder: (_, __) => const DiaryScreen(),
          // routes: [
          //   GoRoute(
          //     path: 'diary/:id',
          //     builder: (_, state) => DiaryDetailScreen(
          //       id: state.pathParameters['id']!,
          //     ),
          //   ),
          // ],
        ),
        GoRoute(
          path: '/album',
          name: AlbumScreen.routeName,
          builder: (_, __) => AlbumScreen(),
        ),
        GoRoute(
          path: '/help-chat',
          name: HelpChatScreen.routeName,
          builder: (_, __) => HelpChatScreen(),
        ),
      ];

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final logginIn = state.location == '/login';

    // 유저 정보가 없는데 로그인 중이라면 그대로 로그인 페이지에 두고
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logginIn ? null : '/login';
    }

    // user가 null이 아님
    // 사용자 정보가 있다면 록읜 중이거나 현재 위치가 splash이면 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }

  logout() {
    // 실행이 되는 순간에만 provider를 읽어서 실행한다.
    // 클래스 전체의 디펜던시는 아니다. 함수를 실행하는 순간에 알 수 있다.
    // 하지만 inject를 할 때는 빌드 타임에 알고 있어야 한다.
    ref.read(userMeProvider.notifier).logout();
  }
}
