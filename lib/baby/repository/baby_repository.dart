import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../common/constant/data.dart';
import '../../common/dio/dio.dart';
import '../model/baby_model.dart';

part 'baby_repository.g.dart';

final babyRepositoryProvider = Provider<BabyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = BabyRepository(dio, baseUrl: 'http://$ip/api/v1/babies/my');
  return repository;
});

@RestApi()
abstract class BabyRepository {

  factory BabyRepository(Dio dio, {String baseUrl}) = _BabyRepository;

  @GET('')
  @Headers({
    'accessToken' : 'true',
  })
  Future<List<BabyModel>> getMyBabies();

}
