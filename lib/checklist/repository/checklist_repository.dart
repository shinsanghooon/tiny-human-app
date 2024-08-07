import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:tiny_human_app/checklist/model/checklist_create_model.dart';
import 'package:tiny_human_app/checklist/model/toggle_all_update_request.dart';
import 'package:tiny_human_app/common/dio/dio.dart';

import '../../common/constant/data.dart';
import '../model/checklist_model.dart';

part 'checklist_repository.g.dart';

final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChecklistRepository(dio, baseUrl: '$ip/api/v1/checklist');
});

@RestApi()
abstract class ChecklistRepository {
  factory ChecklistRepository(Dio dio, {String baseUrl}) = _ChecklistRepository;

  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<ChecklistModel>> getChecklists();

  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<ChecklistModel> registerChecklist({@Body() required ChecklistCreateModel checklistCreateModel});

  @PATCH('')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> updateChecklist({@Body() required ChecklistCreateModel updateChecklist});

  @PATCH('/{checklistId}/detail/{checklistDetailId}/toggle')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> toggleChecklistDetail(
      {@Path('checklistId') required int checklistId, @Path('checklistDetailId') required int checklistDetailId});

  @PATCH('/{checklistId}/toggle-all')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> toggleAllChecklistDetail(
      {@Path('checklistId') required int checklistId, @Body() required ToggleAllUpdateRequest toggleAllUpdateRequest});

  @DELETE('/{checklistId}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> deleteChecklist({@Path('checklistId') required int checklistId});
}
