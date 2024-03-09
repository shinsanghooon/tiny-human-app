import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/helpchat/model/helprequest_model.dart';
import 'package:tiny_human_app/helpchat/provider/help_request_provider.dart';
import 'package:tiny_human_app/helpchat/view/chat_sample.dart';

import '../../baby/view/baby_screen.dart';
import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import 'helpchat_request_screen.dart';

class HelpChatScreen extends ConsumerStatefulWidget {
  static String get routeName => 'helpchat';

  const HelpChatScreen({super.key});

  @override
  ConsumerState<HelpChatScreen> createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends ConsumerState<HelpChatScreen> with SingleTickerProviderStateMixin {
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
    final data = ref.watch(helpRequestProvider);
    print(data[0].toString());

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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: PRIMARY_COLOR),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HelpChatRequestScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted_outlined, color: PRIMARY_COLOR),
                    onPressed: () {
                      print('HELP CHAT 메시지 알림 스크린 만들기');
                    },
                  ),
                ],
              ),
            ],
          ),
          SliverList.separated(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChatSample(
                          // id: 1,
                          // chatData: ChatPageInfo(peerId: 'dfdf1', peerNickname: 'dfd'),
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

  Widget chatCard(HelpRequestModel data) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.contents,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              DateConvertor.convertoToRelativeTime(data.createdAt!),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          data.contents,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 16.0,
          ),
          overflow: TextOverflow.ellipsis,
        )
      ]),
    );
  }
}
