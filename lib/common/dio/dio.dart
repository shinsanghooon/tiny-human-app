import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constant/data.dart';
import '../secure_storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
      CustomInterceptor(storage: storage)
  );

  print('use dio provider');

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    print('[REQ] [BODY] [${options.data}]');

    // 만약에 요청의 Header에 accessToken, true 값이 있다면
    // 실제 토큰을 storage에서 가져와서 헤더를 변경한다.
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      print('[ACCESS TOKEN] ${token}');
      options.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      print('[REFRESH TOKEN] ${token}');
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
    print('[ERROR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    print('[ERROR] [${err.message}]');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // 리프레시 토큰이 아예 없으면 에러를 던진다.
    if (refreshToken == null) {
      // handler.reject로 에러가 생성된다.
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;

    // 토큰을 발급 받으려다가 에러가 난 것이다.
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if (isStatus401 && !isPathRefresh) {
      print('[ERROR] RefreshToken Error');
      final dio = Dio();

      try {
        final response = await dio.post(
          'http://$ip/auth/token',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );
        final accessToken = response.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken'
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송. 헤더만 변경해서
        final newResponse = await dio.fetch(options);
        return handler.resolve(newResponse);
      } on DioError catch (e) {
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
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    print('[RES] [${response.data}]');

    return super.onResponse(response, handler);
  }
}
