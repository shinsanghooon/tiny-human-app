import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_model.dart';
import 'package:tiny_human_app/helpchat/model/helprequest_model.dart';
import 'package:tiny_human_app/helpchat/view/chatting_screen.dart';

import '../../baby/view/baby_screen.dart';
import '../../common/constant/colors.dart';
import '../../common/layout/default_layout.dart';
import '../../user/model/user_model.dart';
import '../../user/provider/user_me_provider.dart';
import '../provider/help_chat_provider.dart';
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
    List<HelpChatModel> helpChatInfo = ref.watch(helpChatProvider);
    // chat info를 조회하는 provider 생성
    // chat info를 조회할 때는 groupChatId를 사용해야 한다.
    // 가져온 데이터로 화면에 뿌린다.
    // 그냥 rdb에 컬럼 추가해서 저장할까?
    // 그게 나을듯!

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
                      // 내가 요청한 help, 내가 푸시 받은 help를 표시하는 메뉴
                    },
                  ),
                ],
              ),
            ],
          ),
          SliverList.separated(
            itemCount: helpChatInfo.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  UserModel user = await ref.read(userMeProvider.notifier).getMe();
                  int userId = user.id;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChattingScreen(
                            userId: userId,
                            model: helpChatInfo[index],
                          )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 24.0,
                    left: 24.0,
                    top: 8.0,
                  ),
                  child: chatCard(
                    helpChatInfo[index].helpRequest!,
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
