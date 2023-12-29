import 'package:flutter/material.dart';

import '../../common/layout/default_layout.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<String> messages = [];
  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    setState(() {
      messages.add(messageController.text);
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: 'HELP CHAT',
      child: Column(
        children: [],
      ),
    );
  }
}
