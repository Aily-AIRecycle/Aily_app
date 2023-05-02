import 'package:Aily/utils/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../class/UserData.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double screenWidth, screenHeight;
  late String? username;
  late int? userpoint;
  Color myColor = const Color(0xFFF8B195);

  @override
  void initState() {
    super.initState();
    _getScreenSize();
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getScreenSize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        screenWidth = MediaQuery.of(context).size.width;
        screenHeight = MediaQuery.of(context).size.height;
      });
    });
  }

  void _getUser() {
    UserData user = UserData();
    setState(() {
      username = user.nickname;
      userpoint = user.point;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backColor = Colors.white;
    return Scaffold(
      backgroundColor: backColor,
      body: HomeWidget(username!, context),
    );
  }

  Widget HomeWidget(String username, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 45),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: screenHeight * 0.007,
                      left: screenWidth * 0.05,
                      child: Text(
                        "AILY",
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Waiting for the Sunrise',
                          fontWeight: FontWeight.bold,
                          color: myColor,
                        ),
                      ),
                    ),
                    Positioned(

                      top: screenHeight * 0.02,
                      left: screenWidth * 0.84,
                      child: GestureDetector(
                        onTap: () {
                          // 클릭 시 실행될 코드
                          showMsg(context, "테스트", "테스트");
                        },
                        child: SvgPicture.asset(
                          'assets/images/icons/notification_line_icon.svg',
                          width: 24, // 이미지 크기
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.075,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/icons/wallet.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            '님의 포인트',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Text(
                          '$userpoint',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            fixedSize: const Size(300, 60),
                            shadowColor: Color(0xffF8B195).withOpacity(0.25),
                            backgroundColor: Color(0xFFF8B195).withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 30.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),

                            ),

                          ),
                          child: const Text(
                            '적립내역',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}