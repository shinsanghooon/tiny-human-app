import 'package:flutter/material.dart';

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
            color: isMe ? Colors.grey[300] : Colors.blueAccent,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0)),
          ),
          width: 150,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
