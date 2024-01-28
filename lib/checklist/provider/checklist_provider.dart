import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/checklist_detail_model.dart';
import '../model/checklist_model.dart';

final checklistProvider =
    StateNotifierProvider<ChecklistNotifier, List<ChecklistModel>>((ref) {
  return ChecklistNotifier();
});

class ChecklistNotifier extends StateNotifier<List<ChecklistModel>> {
  ChecklistNotifier()
      : super([
          ChecklistModel(
            id: 1,
            title: '😀 문화센터 갈 때',
            checklist: [
              ChecklistDetailModel(id: 1, content: '속옷', isChecked: true),
              ChecklistDetailModel(id: 2, content: '기저귀', isChecked: false),
              ChecklistDetailModel(id: 3, content: '분유', isChecked: false),
            ],
          ),
          ChecklistModel(
            id: 2,
            title: '🚗 멀리 여행갈 때',
            checklist: [
              ChecklistDetailModel(id: 4, content: '속옷', isChecked: true),
              ChecklistDetailModel(id: 5, content: '기저귀', isChecked: false),
              ChecklistDetailModel(id: 6, content: '분유', isChecked: false),
              ChecklistDetailModel(id: 7, content: '홈캠', isChecked: false),
              ChecklistDetailModel(id: 8, content: '이불', isChecked: false),
              ChecklistDetailModel(id: 9, content: '이유식', isChecked: false),
            ],
          ),
          ChecklistModel(
            id: 3,
            title: '☕️ 동네 카페',
            checklist: [
              ChecklistDetailModel(id: 10, content: '속옷', isChecked: true),
              ChecklistDetailModel(id: 11, content: '기저귀', isChecked: false),
              ChecklistDetailModel(id: 12, content: '우유', isChecked: false),
              ChecklistDetailModel(id: 13, content: '스티커', isChecked: false),
            ],
          )
        ]) {}

  void addChecklist(ChecklistModel model) {
    state = [...state, model];
  }

  void updateChecklist(ChecklistModel updatedModel) {
    state = state
        .map((e) => e.id == updatedModel.id
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
    return state.where((e) => e.id == id).toList().first;
  }
}
