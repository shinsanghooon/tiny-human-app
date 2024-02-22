import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageInput extends StatefulWidget {
  const NewMessageInput({super.key});

  @override
  State<NewMessageInput> createState() => _NewMessageInputState();
}

class _NewMessageInputState extends State<NewMessageInput> {
  final _textController = TextEditingController();
  String _userEnterMessage = '';

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'date': Timestamp.now(),
      'userId': user!.uid,
    });
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              print('upload photo');
            },
            icon: Icon(Icons.photo_outlined),
            color: Colors.blue,
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
