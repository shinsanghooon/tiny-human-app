import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/common/dio/dio.dart';
import 'package:tiny_human_app/user/model/user_model.dart';
import 'package:tiny_human_app/user/model/user_push_response.dart';

import '../../common/constant/data.dart';
import '../model/notification_settings_update_model.dart';
import '../model/user_push_create_model.dart';

part 'user_me_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserMeRepository(dio, baseUrl: '$ip/api/v1');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dip, {String baseUrl}) = _UserMeRepository;

  @GET('/users/{userId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getMe({@Path('userId') required int id});

  @POST('/users/tokens')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserPushResponse> registerFcmTokenAndDeviceInfo({@Body() required UserPushCreateModel userPushCreate});

  @PATCH('/users/{userId}/settings/notifications')
  @Headers({'accessToken': 'true'})
  Future<UserModel> updateNotificationSettings(
      {@Path('userId') required int id, @Body() required NotificationSettingsUpdates notificationSettingUpdate});
}
