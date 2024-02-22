import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiny_human_app/helpchat/component/chat_bubblle.dart';

import '../component/new_message_input.dart';

class ChatSample extends StatefulWidget {
  const ChatSample({super.key});

  @override
  State<ChatSample> createState() => _ChatSampleState();
}

class _ChatSampleState extends State<ChatSample> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat screen'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                _authentication.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc('o9MSpDN5YUkkeuIykmrG')
                      .collection('message')
                      .orderBy('date', descending: true)
                      .limit(20)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    print(docs[0].data());

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(message: docs[0]['text'], isMe: false);
                      },
                    );
                  },
                ),
              ),
              NewMessageInput(),
            ],
          ),
        ));
  }
}
