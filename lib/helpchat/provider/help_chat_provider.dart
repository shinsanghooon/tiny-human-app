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

  Future<HelpChatModel> addHelpChat(HelpChatCreateModel model) async {
    final response = await repository.registerChatRequest(helpChatCreateModel: model);
    state = [response, ...state];
    return response;
  }

  Future<void> getHelpChat() async {
    state = await repository.getHelpChat();
  }

  Future<void> updateLatestMessage(int helpChatId, HelpChatLatestMessage helpChatLatestMessage) async {
    await repository.updateLatestMessage(
      helpChatId: helpChatId,
      helpChatLatestMessage: helpChatLatestMessage,
    );

    // TODO 이걸 캐시 업데이트 하면 채팅을 보는 상대방 화면은 업데이트가 안됨.
    state = state.map((e) {
      return e.id == helpChatId
          ? HelpChatModel(
              id: e.id,
              helpRequestId: e.helpRequestId,
              helpRequestUserId: e.helpRequestUserId,
              helpAnswerUserId: e.helpAnswerUserId,
              helpRequest: e.helpRequest,
              latestMessage: helpChatLatestMessage.message,
              latestMessageTime: helpChatLatestMessage.messageTime,
            )
          : e;
    }).toList();
  }
}
