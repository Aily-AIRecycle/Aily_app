import 'package:flutter/material.dart';

class PushScreen extends StatefulWidget {
  const PushScreen({Key? key}) : super(key: key);

  @override
  PushScreenState createState() => PushScreenState();
}

class PushScreenState extends State<PushScreen> {
  Color myColor = const Color(0xFFF8B195);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('알림', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: pushWidget(context),
    );
  }

  Widget pushWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.message_outlined, size: 45, color: Colors.black54),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Text(
            '수신된 알림이 없습니다.',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 17,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      )
    );
  }
}