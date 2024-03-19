import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../common/constant/data.dart';
import '../../common/dio/dio.dart';
import '../model/baby_model.dart';
import '../model/baby_model_with_presigned.dart';

part 'baby_repository.g.dart';

final babyRepositoryProvider = Provider<BabyRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = BabyRepository(dio, baseUrl: 'http://$ip/api/v1/babies');
  return repository;
});

@RestApi()
abstract class BabyRepository {
  factory BabyRepository(Dio dio, {String baseUrl}) = _BabyRepository;

  @GET('/my')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<BabyModel>> getMyBabies();

  @PATCH('/{babyId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<BabyModel> updateBaby({@Path('babyId') required int id, @Body() required Map<String, dynamic> body});

  @PATCH('/{babyId}/image')
  @Headers({
    'accessToken': 'true',
  })
  Future<BabyModelWithPreSigned> updateBabyProfile(
      {@Path('babyId') required int id, @Body() required Map<String, dynamic> body});

  @DELETE('/{babyId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> deleteBaby({@Path('babyId') required int id});
}
