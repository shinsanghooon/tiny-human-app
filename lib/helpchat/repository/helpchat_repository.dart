import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/common/dio/dio.dart';
import 'package:tiny_human_app/helpchat/model/helprequest_create_model.dart';

import '../../common/constant/data.dart';
import '../model/helpchat_create_model.dart';
import '../model/helpchat_latest_message.dart';
import '../model/helpchat_model.dart';
import '../model/helprequest_model.dart';

part 'helpchat_repository.g.dart';

final helpChatRepositoryProvider = Provider<HelpChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return HelpChatRepository(dio, baseUrl: 'http://$ip/api/v1/helpchat');
});

@RestApi()
abstract class HelpChatRepository {
  factory HelpChatRepository(Dio dio, {String baseUrl}) = _HelpChatRepository;

  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<HelpChatModel>> getHelpChat();

  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<HelpChatModel> registerChatRequest({@Body() required HelpChatCreateModel helpChatCreateModel});

  @GET('/help-request')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<HelpRequestModel>> getHelpRequest();

  @POST('/help-request')
  @Headers({
    'accessToken': 'true',
  })
  Future<HelpRequestModel> registerHelpRequest({@Body() required HelpRequestCreateModel helpChatCreateModel});

  @PATCH('/{helpChatId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> updateLatestMessage(
      {@Path('helpChatId') required int helpChatId, @Body() required HelpChatLatestMessage helpChatLatestMessage});
}
