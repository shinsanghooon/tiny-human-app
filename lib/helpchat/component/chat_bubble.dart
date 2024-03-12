import 'package:flutter/material.dart';
import 'package:tiny_human_app/common/constant/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatBubble({
    required this.message,
    required this.isMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[200] : PRIMARY_COLOR,
            borderRadius: const BorderRadius.all(Radius.circular(18.0)),
          ),
          width: message.length > 20 ? 200 : null,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.white,
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }
}
