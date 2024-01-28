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

  }

  void addChecklist(ChecklistModel model) {
    state = [...state, model];
  }

  void updateChecklist(ChecklistModel updatedModel) {
    state = state
        .map((e) =>
    e.id == updatedModel.id
        ? ChecklistModel(
        id: updatedModel.id,
        title: updatedModel.title,
        checklist: updatedModel.checklist)
        : e)
        .toList();
  }

  void deleteChecklist(int id) {
    state = state.where((e) => e.id != id).toList();
  }

  ChecklistModel getChecklist(int id) {
    return state
        .where((e) => e.id == id)
        .toList()
        .first;
  }
}
