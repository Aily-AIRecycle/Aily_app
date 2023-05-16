import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class register3Screen extends StatefulWidget {
  const register3Screen({Key? key}) : super(key: key);

  @override
  _register3ScreenState createState() => _register3ScreenState();
}

class _register3ScreenState extends State<register3Screen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: RegisterWidget(context),
      ),
    );
  }

  Widget RegisterWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                '환영합니다 !',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.623),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: myColor.withOpacity(0.9),
            backgroundColor: myColor.withOpacity(0.9),
            elevation: 0.9,
            fixedSize: Size(MediaQuery.of(context).size.width * 1.0, MediaQuery.of(context).size.height * 0.07),
          ),
          child: const Text(
            '확인',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}