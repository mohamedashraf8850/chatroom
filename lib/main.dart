import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'chat_screen.dart';

void main() {
  runApp(MyApp());
}

String uId;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return MaterialApp(
      title: 'Chat Room',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: chatRoomHome(),
    );
  }
}

class chatRoomHome extends StatefulWidget {
  @override
  chatRoomHomeState createState() => chatRoomHomeState();
}

class chatRoomHomeState extends State<chatRoomHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ChatScreen(),
    );
  }

  @override
  void initState() {
    getDeviceDetails();
    super.initState();
  }

  void getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      var build = await deviceInfoPlugin.androidInfo;
      uId =  build.model + build.androidId[0];
    } on PlatformException {
      print('Failed to get platform version');
    }
  }
}
