import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/baby/model/baby_model.dart';

import '../repository/baby_repository.dart';

final babyProvider =
    StateNotifierProvider<BabyNotifier, List<BabyModel>>((ref) {
  final repository = ref.watch(babyRepositoryProvider);
  return BabyNotifier(repository: repository);
});

class BabyNotifier extends StateNotifier<List<BabyModel>> {
  final BabyRepository repository;

  BabyNotifier({
    required this.repository,
  }) : super([]) {
    getMyBabies();
  }

  Future<void> getMyBabies() async {
    final response = await repository.getMyBabies();
    state = response;
  }

  void addBaby(BabyModel baby) {
    state = [
      ...state,
      baby
    ];
  }
}
