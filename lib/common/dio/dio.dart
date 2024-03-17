import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tiny_human_app/user/provider/auth_provider.dart';

import '../constant/data.dart';
import '../secure_storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomInterceptor(storage: storage, ref: ref));
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.storage, required this.ref});

  // 1) 요청을 보낼때
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('[REQ] [${options.method}] ${options.uri}');
    debugPrint('[REQ] [BODY] [${options.data}]');

    // 만약에 요청의 Header에 accessToken, true 값이 있다면
    // 실제 토큰을 storage에서 가져와서 헤더를 변경한다.
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      debugPrint('[ACCESS TOKEN] $token');
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      debugPrint('[REFRESH TOKEN] ${token}');
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    // 실제 요청이 보내지는 순간
    return super.onRequest(options, handler);
  }

  // 3. 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.
    debugPrint('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri} ${err.requestOptions.path}');
    debugPrint('[ERROR] message: ${err.message}');
    debugPrint('[ERROR] err object: ${err}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // 리프레시 토큰이 아예 없으면 에러를 던진다.
    if (refreshToken == null) {
      // handler.reject로 에러가 생성된다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    print(err.response?.statusCode);
    print(err.response?.data);

    // 토큰을 발급 받으려다가 에러가 난 것이다.
    final isPathRefresh = err.requestOptions.path == '/api/v1/token';
    print(err.requestOptions.path);
    print(isPathRefresh);
    print('refreshToken $refreshToken');

    if (isStatus401 && !isPathRefresh) {
      debugPrint('[ERROR] RefreshToken Error');
      final dio = Dio();

      print('!!!!');
      try {
        final response = await dio.post(
          'http://$ip/api/v1/token',
          data: {'refreshToken': refreshToken},
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );
        final accessToken = response.data['accessToken'];
        print('newAccesstoken: $accessToken');

        final options = err.requestOptions;

        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송. 헤더만 변경해서
        final newResponse = await dio.fetch(options);
        print(newResponse);
        return handler.resolve(newResponse);
      } on DioError catch (e) {
        // jwt 관련 다른 에러(토큰 만료)

        // 여기서 userMeProvider를 불러와서 logout을 해주면
        // circular dependency error가 발생한다.
        // userMeProvider -> dio -> userMeProvider -> dio ...
        ref.read(authProvider.notifier).logout();
        return handler.reject(e);
      }
    }

    // 이렇게 하면 실제로 요청한 쪽에서는 에러가 안난 것으로 응답을 받게 된다.
    //return handler.resolve(response);

    return super.onError(err, handler);
  }

  // 2. 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    debugPrint('[RES] [${response.data}]');

    return super.onResponse(response, handler);
  }
}
