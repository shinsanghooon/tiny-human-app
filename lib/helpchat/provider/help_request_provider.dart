import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_create_model.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_model.dart';

import '../repository/help_request_repository.dart';

final helpRequestProvider = StateNotifierProvider<HelpRequestNotifier, List<HelpChatModel>>((ref) {
  final repository = ref.watch(helpRequestRepositoryProvider);
  return HelpRequestNotifier(repository: repository);
});

class HelpRequestNotifier extends StateNotifier<List<HelpChatModel>> {
  final HelpRequestRepository repository;

  HelpRequestNotifier({
    required this.repository,
  }) : super([]) {
    // 레포지토리를 써도 결국 id를 통해 User를 조회해야함
    // accessToken을  서버에 전달하기 때문에 userId를 전달할 필요 없음
    // getHelpRequest();
  }

  void addHelpRequest(HelpChatCreateModel model) async {
    final response = await repository.registerHelpRequest(helpChatCreateModel: model);
    state = [response, ...state];
  }

  Future<void> getHelpRequest() async {
    state = await repository.getHelpRequest();
  }
}
