import 'package:flutter/material.dart';

import '../../models/chat_message.dart';
import '../components/appbar_preferred_size.dart';
import 'conponents/chat_container.dart';

class Chatting extends StatelessWidget {
  const Chatting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        bottom: appBarBottomLine(),
      ),
      body: ListView(
        children: List.generate(
          chatMessageList.length,
          (index) => ChatContainer(chatMessage: chatMessageList[index]),
        ),
      ),
    );
  }
}
