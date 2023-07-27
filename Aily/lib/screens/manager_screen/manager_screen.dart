import 'package:aily/screens/manager_screen/chart_screen.dart';
import 'package:aily/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:aily/utils/show_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gradients/gradients.dart';
import '../login_screen/login_screen.dart';
import '../../class/garbage_data_class.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  ManagerScreenState createState() => ManagerScreenState();
}

class ManagerScreenState extends State<ManagerScreen> {
  Color myColor = const Color(0xFFF8B195);
  final storage = const FlutterSecureStorage();
  GarbageMerch merch = GarbageMerch();

  Future<void> logout() async {
    await storage.delete(key: 'id');
    await storage.delete(key: 'pw');
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      showMsg(context, '로그아웃', '로그아웃 되었습니다.');
    });
  }

  Future<void> widgetScreen(Widget widget) async {
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: managerWidget(context),
      ),
    );
  }

  Widget managerWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '관리자',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.06,
                    left: MediaQuery.of(context).size.width * 0.16,
                    right: MediaQuery.of(context).size.width * 0.16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildNavigationContainer(
                          context,
                          '지도',
                          Icons.location_on,
                          () => widgetScreen(const MapScreen()),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0)),
                        buildNavigationContainer(
                          context,
                          '통계',
                          Icons.bar_chart,
                          () => widgetScreen(const ChartScreen()),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      children: [
                        buildNavigationContainer(
                          context,
                          '설정',
                          Icons.settings,
                          () => () {},
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0)),
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
              )
            ],
          ),
        )
      ],
    );
  }
}

Widget buildNavigationContainer(
  BuildContext context,
  String title,
  IconData icon,
  Function() onTap,
) {
  var screenWidth = MediaQuery.of(context).size.width * 0.33;
  var screenHeight = MediaQuery.of(context).size.height * 0.2;
  Color containerColor = const Color(0xFF87A7dD);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradientPainter(
            colors: [containerColor, containerColor, containerColor]),
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
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
