import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/helpchat/component/chat_bubble.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_model.dart';

import '../../common/constant/firestore_constants.dart';
import '../component/new_message_input.dart';

class ChattingScreen extends ConsumerStatefulWidget {
  final int userId;
  final HelpChatModel model;

  const ChattingScreen({required this.userId, required this.model, super.key});

  @override
  ConsumerState<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends ConsumerState<ChattingScreen> {
  User? loggedUser;

  final _chatInputController = TextEditingController();
  final _listScrollController = ScrollController();

  int? userId;
  int? peerId;
  int? helpChatId;
  int? chatRequestUserId;
  int? chatAnswerUserId;
  int? helpRequestId;
  String _groupChatId = "";
  String title = "";

  List<QueryDocumentSnapshot> _listMessage = [];
  int _limit = 20;
  final _limitIncrement = 20;

  @override
  void initState() {
    super.initState();

    userId = widget.userId;
    helpChatId = widget.model.id;
    chatRequestUserId = widget.model.helpRequestUserId;
    chatAnswerUserId = widget.model.helpAnswerUserId;
    helpRequestId = widget.model.helpRequestId;
    title = widget.model.helpRequest!.contents.length > 30
        ? widget.model.helpRequest!.contents.substring(0, 30)
        : widget.model.helpRequest!.contents;

    if (userId == chatRequestUserId) {
      peerId = chatAnswerUserId;
    } else {
      peerId = chatRequestUserId;
    }

    if (userId! > peerId!) {
      _groupChatId = '$helpRequestId-$userId-$peerId';
    } else {
      _groupChatId = '$helpRequestId-$peerId-$userId';
    }

    // _focusNode.addListener(_onFocusChange);
    _listScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _chatInputController.dispose();
    _listScrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_listScrollController.hasClients) return;
    if (_listScrollController.offset >= _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange &&
        _limit <= _listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '채팅',
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
        body: GestureDetector(
          onTap: () {
            // 현재 포커스를 가진 위젯에서 포커스를 제거하여 키보드를 숨김
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreConstants.pathMessageCollection)
                      .doc(_groupChatId)
                      .collection(_groupChatId)
                      .orderBy('date', descending: true)
                      .limit(_limit)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    _listMessage = snapshot.data!.docs;
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        // TODO 키 수정하기
                        key: const PageStorageKey('key'),
                        itemCount: _listMessage.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(
                              message: _listMessage[index]['text'], isMe: _listMessage[index]['fromId'] == userId!);
                        },
                        reverse: true,
                        shrinkWrap: true,
                        controller: _listScrollController,
                      ),
                    );
                  },
                ),
              ),
              NewMessageInput(
                title: title,
                fromId: userId!,
                toId: peerId!,
                helpChatId: helpChatId!,
                chatRequestUserId: chatRequestUserId!,
                chatAnswerUserId: chatAnswerUserId!,
                groupChatId: _groupChatId,
                controller: _listScrollController,
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ));
  }
}
