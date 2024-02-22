import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constant/data.dart';
import '../../common/dio/dio.dart';
import '../../common/model/token_response.dart';
import '../model/login_response.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return AuthRepository(baseUrl: 'http://$ip/api/v1', dio: dio);
});

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post('$baseUrl/auth/login', data: {
      "email": email,
      "password": password,
    });
    return LoginResponse.fromJson(response.data);
  }

  Future<TokenResponse> token() async {
    final response = await dio.post('$baseUrl/token',
        options: Options(headers: {
          'refreshToken': 'true',
        }));

    return TokenResponse.fromJson(response.data);
  }

  Future<LoginResponse> googleLogin({
    required String email,
    required String accessToken,
    required String name,
    required String photoURL,
  }) async {
    final response = await dio.post('$baseUrl/auth/google', data: {
      "email": email,
      "socialAccessToken": accessToken,
      "name": name,
      "photoUrl": photoURL,
    });
    return LoginResponse.fromJson(response.data);
  }
}
