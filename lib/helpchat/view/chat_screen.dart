import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final int id;

  const ChatScreen({
    required this.id,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('채팅 화면'));
  }
}
