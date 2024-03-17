import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tiny_human_app/common/utils/date_convertor.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_create_model.dart';
import 'package:tiny_human_app/helpchat/provider/help_chat_provider.dart';
import 'package:tiny_human_app/helpchat/provider/help_request_provider.dart';
import 'package:tiny_human_app/helpchat/view/chatting_screen.dart';

import '../../common/constant/colors.dart';

class HelpRequestListScreen extends ConsumerStatefulWidget {
  final int userId;

  const HelpRequestListScreen({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<HelpRequestListScreen> createState() => _HelpRequestListScreenState();
}

class _HelpRequestListScreenState extends ConsumerState<HelpRequestListScreen> {
  int _openedTileIndex = -1; // 아무것도 안 열린 상태
  bool showOnlyMyPost = false;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(helpRequestProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '도움이 필요해요',
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: PRIMARY_COLOR,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 14.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showOnlyMyPost = !showOnlyMyPost;
                  });
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      showOnlyMyPost
                          ? Icon(
                              Icons.check_circle,
                              size: 20.0,
                              color: MAIN_GREEN_COLOR,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              size: 20.0,
                            ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '내가 쓴 글만 보기',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListView.separated(
              // 여기에 key를 넣어줘야지 하나가 열렸을 때 다른 탭이 닫힌다. 하지만 애니메이션이 깨진다...
              // 확인해보기!
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // 내가 쓴 글만 보기에 체크를 했는데, userId가 다를 때는 보여주지 않는다.
                if (showOnlyMyPost && widget.userId != data[index].userId) {
                  return null;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ExpansionTile(
                    key: ValueKey(data[index].id),
                    onExpansionChanged: (bool expanding) {
                      setState(() {
                        _openedTileIndex = expanding ? index : -1;
                      });
                    },
                    initiallyExpanded: _openedTileIndex == index,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index].contents,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          DateConvertor.convertoToRelativeTime(data[index].createdAt!),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: TEXT_BACKGROUND_COLOR,
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  data[index].contents,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            widget.userId != data[index].userId
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final chatList = ref.read(helpChatProvider);
                                        bool isExistedChat = chatList.any((chat) =>
                                            chat.helpRequestId == data[index].id &&
                                            chat.helpRequestUserId == widget.userId &&
                                            chat.helpAnswerUserId == data[index].userId);

                                        if (isExistedChat) {
                                          Fluttertoast.showToast(
                                            msg: '이미 존재하는 채팅입니다. 😅',
                                            gravity: ToastGravity.CENTER,
                                            textColor: Colors.white,
                                            backgroundColor: Colors.black54,
                                            fontSize: 20.0,
                                          );
                                          // TODO 기존에 채팅이 있는지 확인하고 만약 있다면 해당 화면으로 이동시켜줘야함.
                                          return;
                                        }

                                        final helpChatCreateModel = HelpChatCreateModel(
                                          helpRequestId: data[index].id,
                                          helpRequestUserId: widget.userId,
                                          helpAnswerUserId: data[index].userId,
                                        );

                                        final helpChatModel =
                                            await ref.read(helpChatProvider.notifier).addHelpChat(helpChatCreateModel);

                                        if (mounted) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ChattingScreen(
                                                userId: widget.userId,
                                                model: helpChatModel,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "채팅하기",
                                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: PRIMARY_COLOR,
                                      ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: '내가 작성한 글입니다. 😅',
                                          gravity: ToastGravity.CENTER,
                                          textColor: Colors.white,
                                          backgroundColor: Colors.black54,
                                          fontSize: 20.0,
                                        );
                                      },
                                      child: ElevatedButton(
                                        onPressed: null,
                                        child: Text(
                                          "채팅하기",
                                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: showOnlyMyPost ? data.where((d) => d.userId == widget.userId).length : data.length,
              separatorBuilder: (context, index) => const Divider(
                color: DIVIDER_COLOR,
                indent: 16.0,
                endIndent: 16.0,
                height: 0.0,
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}
