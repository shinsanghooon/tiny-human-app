import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiny_human_app/common/constant/colors.dart';
import 'package:tiny_human_app/helpchat/model/helpchat_latest_message.dart';
import 'package:tiny_human_app/helpchat/provider/help_chat_provider.dart';

import '../../common/constant/firestore_constants.dart';

class NewMessageInput extends ConsumerStatefulWidget {
  final String title;
  final int fromId;
  final int toId;
  final int helpChatId;
  final int chatRequestUserId;
  final int chatAnswerUserId;
  final String groupChatId;
  final ScrollController controller;

  const NewMessageInput({
    required this.title,
    required this.fromId,
    required this.toId,
    required this.helpChatId,
    required this.chatRequestUserId,
    required this.chatAnswerUserId,
    required this.groupChatId,
    required this.controller,
    super.key,
  });

  @override
  ConsumerState<NewMessageInput> createState() => _NewMessageInputState();
}

class _NewMessageInputState extends ConsumerState<NewMessageInput> {
  final _textController = TextEditingController();
  String inputMessage = '';

  void _sendMessage() async {
    // FocusScope.of(context).unfocus();
    _textController.clear();

    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(widget.groupChatId)
        .collection(widget.groupChatId)
        .add(
      {
        'text': inputMessage,
        'fromId': widget.fromId,
        'toId': widget.toId,
        'date': Timestamp.now(),
      },
    );

    FirebaseFirestore.instance.collection(FirestoreConstants.pathChatCollection).doc(widget.groupChatId).set(
      {
        'id': widget.helpChatId,
        'title': widget.title,
        'latest_message': inputMessage,
        'date': Timestamp.now(),
        // chatRequestUserId: help를 요청한 사람
        // chatAnswerUserId: help에 대답을 한 사람
        'request_user_id': widget.chatRequestUserId,
        'response_user_id': widget.chatAnswerUserId,
      },
    );

    await ref.read(helpChatProvider.notifier).updateLatestMessage(
          widget.helpChatId,
          HelpChatLatestMessage(
            helpRequestUserId: widget.chatRequestUserId,
            helpAnswerUserId: widget.chatAnswerUserId,
            message: inputMessage,
            messageTime: DateTime.now(),
          ),
        );

    if (widget.controller.hasClients) {
      widget.controller.animateTo(
        // reverse를 해줬으므로, minScrollExtent를 해줘야 함!
        widget.controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO
              print('TBD');
            },
            icon: const Icon(Icons.add),
            color: PRIMARY_COLOR,
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _textController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                hintText: '메시지를 작성해주세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              onChanged: (value) {
                setState(() {
                  inputMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              inputMessage.trim().isEmpty ? null : _sendMessage();
            },
            icon: const Icon(Icons.send),
            color: PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }
}
