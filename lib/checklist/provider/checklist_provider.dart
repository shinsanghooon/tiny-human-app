import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    print('getMyChecklist');
    final response = await repository.getChecklists();
    state = response;
  }
}
