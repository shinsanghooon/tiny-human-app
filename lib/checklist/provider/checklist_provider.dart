import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/checklist/model/checklist_detail_model.dart';

import '../model/checklist_model.dart';
import '../repository/checklist_repository.dart';

final checklistProvider =
    StateNotifierProvider<ChecklistNotifier, List<ChecklistModel>>((ref) {
  final repository = ref.watch(checklistRepositoryProvider);
  return ChecklistNotifier(repository: repository);
});

class ChecklistNotifier extends StateNotifier<List<ChecklistModel>> {
  final ChecklistRepository repository;

  ChecklistNotifier({
    required this.repository,
  }) : super([]) {
    // 레포지토리를 써도 결국 id를 통해 User를 조회해야함
    // accessToken을  서버에 전달하기 때문에 userId를 전달할 필요 없음
    getMyChecklist();
  }

  void addChecklist(ChecklistModel model) {
    state = [...state, model];
  }

  void toggleChecklistDetail(int checklistId, int checklistDetailId) async {
    await repository.toggleChecklistDetail(
        checklistId: checklistId, checklistDetailId: checklistDetailId);

    state = state.map((e) {
      return ChecklistModel(
          id: e.id,
          title: e.title,
          checklistDetail: e.checklistDetail
              .map((c) => c.id == checklistDetailId
                  ? ChecklistDetailModel(
                      id: c.id,
                      contents: c.contents,
                      reason: c.reason,
                      isChecked: !c.isChecked)
                  : c)
              .toList());
    }).toList();
  }

  void toggleAllChecklistDetail(int checklistId) async {
    await repository.toggleAllChecklistDetail(checklistId: checklistId);

    ChecklistModel checklist = state.where((cl) => cl.id == checklistId).first;
    final checkedList =
        checklist.checklistDetail.map((e) => e.isChecked).toList();
    bool isAllChecklistDetailChecked =
        checkedList.where((e) => e == false).toList().isEmpty;
    bool targetChecked = isAllChecklistDetailChecked ? true : false;

    state = state.map((e) {
      return ChecklistModel(
          id: e.id,
          title: e.title,
          checklistDetail: e.checklistDetail
              .map((c) => ChecklistDetailModel(
                  id: c.id,
                  contents: c.contents,
                  reason: c.reason,
                  isChecked: targetChecked))
              .toList());
    }).toList();
  }

  void updateChecklist(ChecklistModel updatedModel) {
    state = state
        .map((e) => e.id == updatedModel.id
            ? ChecklistModel(
                id: updatedModel.id,
                title: updatedModel.title,
                checklistDetail: updatedModel.checklistDetail)
            : e)
        .toList();
  }

  void deleteChecklist(int id) {
    state = state.where((e) => e.id != id).toList();
  }

  ChecklistModel getChecklist(int id) {
    return state.where((e) => e.id == id).toList().first;
  }

  Future<void> getMyChecklist() async {
    final response = await repository.getChecklists();
    state = response;
    // state = [];
  }
}
