import 'dart:typed_data';
import 'package:Aily/screens/account_screen.dart';
import 'package:Aily/screens/map_screen.dart';
import 'package:flutter/material.dart';
import '../screens/dictionary_screen.dart';
import '../screens/qr_Screen.dart';
import '../screens/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  _NavigatorScreenState createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> with TickerProviderStateMixin{
  Color myColor = const Color(0xFFF8B195);
  late String? username;
  late Uint8List? profile;
  late List<Widget> _children;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  // 플로팅 버튼이 위치할 위치를 지정합니다.
  final double fabBottomMargin = 16.0;

  // 키보드가 올라올 때 플로팅 버튼의 위치를 조정합니다.
  double? _fabTopMargin;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward(from: 0.0);

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        if (visible) {
          _fabTopMargin = null;
        } else {
          _fabTopMargin = fabBottomMargin;
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      const HomeScreen(),
      const dictionaryScreen(),
      const MapScreen(),
      const Account_screen()
    ];
    Widget _IconButton(String icon, int index) {
      return Column(
        children: [
          IconButton(
            iconSize: 40,
            icon: SvgPicture.asset(
              'assets/images/icons/$icon.svg',
              color: _currentIndex == index ? myColor : Colors.grey,
            ),
            onPressed: () {
              _onTap(index);
            },
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _children.map((e) => FadeTransition(
          opacity: _animation,
          child: e,
        )).toList(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              _IconButton('home_icon', 0),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              _IconButton('story_icon', 1),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              _IconButton('map_icon', 2),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              _IconButton('profile_tab_icon', 3),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QRScreen(),
            ),
          );
        },
        backgroundColor: myColor,
        foregroundColor: Colors.white,
        elevation: 5.0,
        child: const Icon(Icons.qr_code, size: 40.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _animationController.forward(from: 0.0);
      pageController.jumpToPage(index);
    }
  }
}

