import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/helpchat/view/helpchat_detail_screen.dart';

import '../../baby/view/baby_screen.dart';
import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../model/chat_page_info.dart';
import 'helpchat_request_screen.dart';

class HelpChatScreen extends StatefulWidget {
  static String get routeName => 'helpchat';

  const HelpChatScreen({super.key});

  @override
  State<HelpChatScreen> createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends State<HelpChatScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        'id': 10,
        'title': '근처에 기저귀 갈이대 있나요? 정말 급해요 롱롱 텍스트',
        'last_chatted': DateTime.now(),
        'last_message': "감사합니다. 도움이 되었어요!",
      },
      {
        'id': 1,
        'title': '근처에 기저귀 갈이대 있나요?',
        'last_chatted': DateTime.now(),
        'last_message': "감사합니다. 도움이 되었어요!",
      },
      {
        'id': 2,
        'title': '명절에 오픈하는 키즈카페 있나요?',
        'last_chatted': DateTime(2024, 2, 10),
        'last_message': "감사합니다. 도움이 되었어요!"
      },
      {
        'id': 3,
        'title': '아기랑 갈만한 카페 추천해주세요.',
        'last_chatted': DateTime(2024, 1, 24),
        'last_message': "감사합니다. 도움이 되었어요!"
      },
      {
        'id': 4,
        'title': '열이나요ㅠㅠ',
        'last_chatted': DateTime(2023, 12, 15),
        'last_message': "감사합니다. 도움이 되었어요!",
      }
    ];

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
            leading: IconButton(
                icon: const Icon(Icons.home_outlined, color: PRIMARY_COLOR),
                onPressed: () => context.goNamed(BabyScreen.routeName)),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: PRIMARY_COLOR),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HelpChatRequestScreen(),
                    ),
                  );
                },
              )
            ],
          ),
          SliverList.separated(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChatScreen(
                            id: 1,
                            chatData: ChatPageInfo(peerId: 'dfdf1', peerNickname: 'dfd'),
                          )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                    top: 8.0,
                  ),
                  child: chatCard(
                    data[index],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 14.0);
            },
          ),
        ]),
      ),
    );
  }

  Widget chatCard(data) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data['title'],
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              DateConvertor.convertoToRelativeTime(data['last_chatted']),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          data['last_message'],
          maxLines: 2,
        )
      ]),
    );
  }
}
