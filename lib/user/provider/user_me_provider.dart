import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiny_human_app/common/constant/data.dart';
import 'package:tiny_human_app/common/secure_storage/secure_storage.dart';
import 'package:tiny_human_app/user/model/user_model.dart';
import 'package:tiny_human_app/user/model/user_push_create_model.dart';
import 'package:tiny_human_app/user/repository/auth_repository.dart';

import '../../common/utils/device_info.dart';
import '../repository/user_me_repository.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final repository = ref.watch(userMeRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);

  return UserMeStateNotifier(
    authRepository: authRepository,
    repository: repository,
    storage: storage,
  );
});

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<UserModel> getMe() async {
    if (state != null) {
      return state as UserModel;
    }

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      state = null;
      throw Exception("사용자 정보를 찾을 수 없습니다.");
    }

    final jwt = JWT.decode(accessToken);
    final response = await repository.getMe(id: jwt.payload['userId'] as int);

    state = response;
    return response;
  }

  Future<UserModelBase> login({required String email, required String password}) async {
    try {
      state = UserModelLoading();

      final response = await authRepository.login(
        email: email,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: response.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: response.accessToken);

      final jwt = JWT.decode(response.accessToken);
      // 이렇게 요청을 다시 보내서 데이터를 받아오면 서버에서 검증이 됐으니까 유효한 토큰이라는 것을 알 수 있다.
      final userResponse = await repository.getMe(id: jwt.payload['userId'] as int);
      state = userResponse;

      final deviceUniqueId = await getDeviceUniqueId();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await repository.registerFcmTokenAndDeviceInfo(
            userPushCreate: UserPushCreateModel(fcmToken: newToken!, deviceInfo: deviceUniqueId));
      });
      await repository.registerFcmTokenAndDeviceInfo(
          userPushCreate: UserPushCreateModel(fcmToken: fcmToken!, deviceInfo: deviceUniqueId));

      print('login!');
      print('state $state');

      return userResponse;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<UserModelBase> googleLogin(
      {required String email, required String accessToken, required String name, required String photoURL}) async {
    try {
      state = UserModelLoading();

      final response = await authRepository.googleLogin(
        email: email,
        accessToken: accessToken,
        name: name,
        photoURL: photoURL,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: response.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: response.accessToken);

      final jwt = JWT.decode(response.accessToken);
      // 이렇게 요청을 다시 보내서 데이터를 받아오면 서버에서 검증이 됐으니까 유효한 토큰이라는 것을 알 수 있다.
      final userResponse = await repository.getMe(id: jwt.payload['userId'] as int);

      final deviceUniqueId = await getDeviceUniqueId();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await repository.registerFcmTokenAndDeviceInfo(
            userPushCreate: UserPushCreateModel(fcmToken: newToken!, deviceInfo: deviceUniqueId));
      });
      await repository.registerFcmTokenAndDeviceInfo(
          userPushCreate: UserPushCreateModel(fcmToken: fcmToken!, deviceInfo: deviceUniqueId));

      state = userResponse;

      print('google login!');
      print('state $state');

      return userResponse;
    } catch (e) {
      state = UserModelError(message: '로그인에 실패했습니다.');
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
      storage.delete(key: FCM_TOKEN),
      GoogleSignIn().signOut(),
      FirebaseAuth.instance.signOut(),
    ]);
    print('logout!');
    print('state $state');
  }
}
