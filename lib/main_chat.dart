import 'package:chatroom/chat_screen.dart';
import 'package:flutter/material.dart';

class MainChatPage extends StatefulWidget {
  @override
  _MainChatPageState createState() => _MainChatPageState();
}
PageController controller = PageController(viewportFraction: 1, keepPage: true);

class _MainChatPageState extends State<MainChatPage> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) {
      return Container(
          child:ChatScreen(),
      );
    },
      controller: controller,
    scrollDirection: Axis.vertical,
    );
  }
}
