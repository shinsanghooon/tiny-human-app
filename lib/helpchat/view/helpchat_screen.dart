import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_model.dart';

import '../../baby/view/baby_screen.dart';
import '../../common/constant/colors.dart';
import '../../common/constant/firestore_constants.dart';
import '../../common/layout/default_layout.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_me_provider.dart';
import '../provider/help_chat_provider.dart';
import 'chatting_screen.dart';
import 'helpchat_request_screen.dart';
import 'helprequest_list_screen.dart';

class HelpChatScreen extends ConsumerStatefulWidget {
  static String get routeName => 'helpchat';

  const HelpChatScreen({super.key});

  @override
  ConsumerState<HelpChatScreen> createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends ConsumerState<HelpChatScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<HelpChatModel> helpChatInfo = ref.watch(helpChatProvider);
    UserModel user = ref.watch(userMeProvider) as UserModel;

    final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection(FirestoreConstants.pathChatCollection)
        .where(Filter.or(Filter('request_user_id', isEqualTo: user.id), Filter('response_user_id', isEqualTo: user.id)))
        .snapshots();

    return DefaultLayout(
      child: RefreshIndicator(
        edgeOffset: 120.0, // TODO: AppBar 높이 알아내서 반영하기
        color: PRIMARY_COLOR,
        onRefresh: () async {},
        child: CustomScrollView(physics: const AlwaysScrollableScrollPhysics(), slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              "HELP CHAT",
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.w800,
              ),
            ),
            toolbarHeight: 64.0,
            leading: IconButton(
                icon: const Icon(Icons.home_outlined, color: PRIMARY_COLOR),
                onPressed: () => context.goNamed(BabyScreen.routeName)),
            actions: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: PRIMARY_COLOR),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HelpRequestRegisterScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.list_alt_outlined, color: PRIMARY_COLOR),
                    onPressed: () async {
                      UserModel user = await ref.read(userMeProvider.notifier).getMe();
                      int userId = user.id;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HelpRequestListScreen(userId: userId),
                        ),
                      );
                      // 내가 요청한 help, 내가 푸시 받은 help를 표시하는 메뉴
                    },
                  ),
                ],
              ),
            ],
          ),
          chattingList(helpChatInfo, chatStream),
        ]),
      ),
    );
  }

  Widget chattingList(List<HelpChatModel> helpChatInfo, Stream<QuerySnapshot> chatStream) {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var items = snapshot.data!.docs;
          return SliverList.separated(
            key: UniqueKey(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  UserModel user = await ref.read(userMeProvider.notifier).getMe();
                  int userId = user.id;

                  if (mounted) {
                    bool isExistedChat = helpChatInfo.any((chat) => chat.id == items[index]['id']);

                    HelpChatModel chatModel;
                    if (!isExistedChat) {
                      chatModel = await ref.read(helpChatProvider.notifier).getNewHelpChat(items[index]['id']);
                    } else {
                      chatModel = helpChatInfo.firstWhere((chat) => chat.id == items[index]['id']);
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChattingScreen(
                          userId: userId,
                          model: chatModel,
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                    top: 8.0,
                  ),
                  child: chatCard(items[index]['title'], items[index]['latest_message'],
                      (items[index]['date'] as Timestamp).toDate()),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: DIVIDER_COLOR,
              indent: 16.0,
              endIndent: 16.0,
            ),
            itemCount: items.length,
          );
        } else if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget chatCard(String title, String? latestMessage, DateTime latestMessageTime) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              DateConvertor.convertoToRelativeTime(latestMessageTime),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          latestMessage ?? "메시지를 보내주세요. 🙂",
          maxLines: 2,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 6.0,
        ),
      ]),
    );
  }
}
