import 'package:flutter/material.dart';
import 'package:graduation_project/screen/information_screen.dart';
import 'information_screen.dart';
import 'mypage_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPageScreen()),
                );
              },
              child: Text(
                '마이페이지 이동',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Text(
                '지도 이동',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
