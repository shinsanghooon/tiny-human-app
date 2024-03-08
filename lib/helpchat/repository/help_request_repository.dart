import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/common/dio/dio.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_create_model.dart';

import '../../common/constant/data.dart';
import '../model/helpchat_model.dart';

part 'help_request_repository.g.dart';

final helpRequestRepositoryProvider = Provider<HelpRequestRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return HelpRequestRepository(dio, baseUrl: 'http://$ip/api/v1/helpchat');
});

@RestApi()
abstract class HelpRequestRepository {
  factory HelpRequestRepository(Dio dio, {String baseUrl}) = _HelpRequestRepository;

  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<HelpChatModel>> getHelpRequest();

  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<HelpChatModel> registerHelpRequest({@Body() required HelpChatCreateModel helpChatCreateModel});
}
