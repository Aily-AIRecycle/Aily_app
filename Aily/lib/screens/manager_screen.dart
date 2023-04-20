import 'package:Aily/screens/home_screen.dart';
import 'package:Aily/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gradients/gradients.dart';
import 'login_screen.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  Color myColor = const Color(0xFFF8B195);
  Color backColor = const Color(0xFFF6F1F6);
  final storage = const FlutterSecureStorage();

  Future<void> logout() async {
    await storage.delete(key: 'id');
    await storage.delete(key: 'pw');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    showMsg(context, '로그아웃', '로그아웃 되었습니다.');
  }

  Future<void> _WidgetScreen(Widget widget) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: ManagerWidget(context),
    );
  }

  Widget ManagerWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              '관리자',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 45),
            Row(
              children: [
                buildNavigationContainer(
                  context,
                  '위치',
                  Icons.location_on,
                      () => _WidgetScreen(const MapScreen()),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                buildNavigationContainer(
                  context,
                  '미정',
                  Icons.settings,
                      () => _WidgetScreen(const HomeScreen()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                buildNavigationContainer(
                  context,
                  '미정',
                  Icons.settings,
                      () => _WidgetScreen(const MapScreen()),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                buildNavigationContainer(
                  context,
                  '미정',
                  Icons.settings,
                      () => _WidgetScreen(const MapScreen()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                buildNavigationContainer(
                  context,
                  '미정',
                  Icons.settings,
                      () => _WidgetScreen(const MapScreen()),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
                buildNavigationContainer(
                  context,
                  '로그아웃',
                  Icons.logout,
                      () => logout(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildNavigationContainer(
    BuildContext context,
    String title,
    IconData icon,
    Function() onTap,
    ) {
  var screenWidth = MediaQuery.of(context).size.width * 0.423;
  var screenHeight = MediaQuery.of(context).size.height * 0.217;
  Color containerColor = const Color(0xFF87A7dD);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradientPainter(
            colors: [containerColor, containerColor, containerColor]
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    ),
  );
}

