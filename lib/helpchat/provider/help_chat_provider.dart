import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_create_model.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_latest_message.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_model.dart';

import '../repository/helpchat_repository.dart';

final helpChatProvider = StateNotifierProvider<HelpChatNotifier, List<HelpChatModel>>((ref) {
  final repository = ref.watch(helpChatRepositoryProvider);
  return HelpChatNotifier(repository: repository);
});

class HelpChatNotifier extends StateNotifier<List<HelpChatModel>> {
  final HelpChatRepository repository;

  HelpChatNotifier({
    required this.repository,
  }) : super([]) {
    // 레포지토리를 써도 결국 id를 통해 User를 조회해야함
    // accessToken을  서버에 전달하기 때문에 userId를 전달할 필요 없음
    getHelpChat();
  }

  void addHelpChat(HelpChatCreateModel model) async {
    final response = await repository.registerChatRequest(helpChatCreateModel: model);
    state = [response, ...state];
  }

  Future<void> getHelpChat() async {
    state = await repository.getHelpChat();
  }

  Future<void> updateLatestMessage(int helpChatId, HelpChatLatestMessage helpChatLatestMessage) async {
    await repository.updateLatestMessage(
      helpChatId: helpChatId,
      helpChatLatestMessage: helpChatLatestMessage,
    );
  }
}
