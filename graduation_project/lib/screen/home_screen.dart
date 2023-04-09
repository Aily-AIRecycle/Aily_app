import 'package:flutter/material.dart';
import 'package:graduation_project/screen/information_screen.dart';
import 'information_screen.dart';
import 'mypage_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPageScreen()),
            );
          },
          child: Text(
            '화면이동',
          ),
        ),
      ),
    );
  }
}
