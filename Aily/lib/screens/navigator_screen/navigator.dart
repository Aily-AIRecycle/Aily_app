import 'dart:typed_data';
import 'package:aily/screens/mypage_screen/mypage_screen.dart';
import 'package:aily/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';
import '../dictionary_screen/category_screen.dart';
import '../qr_screen/qr_screen.dart';
import '../home_screen/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  NavigatorScreenState createState() => NavigatorScreenState();
}

class NavigatorScreenState extends State<NavigatorScreen>
    with TickerProviderStateMixin {
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
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
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
      const CategoryScreen(),
      const MapScreen(),
      const Mypagescreen(),
    ];

    Widget fadeZoomTransition(Widget child) {
      return ScaleTransition(
        scale:
            Tween<double>(begin: 0.99, end: 1.0).animate(_animationController),
        child: FadeTransition(
          opacity: _animation,
          child: child,
        ),
      );
    }

    Widget iconButton(String icon, int index) {
      return IconButton(
        iconSize: 40,
        icon: SvgPicture.asset(
          'assets/images/icons/$icon.svg',
          colorFilter: ColorFilter.mode(
              _currentIndex == index ? myColor : Colors.grey, BlendMode.srcIn),
        ),
        onPressed: () {
          _onTap(index);
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _children.map((e) => fadeZoomTransition(e)).toList(),
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
              iconButton('home_icon', 0),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              iconButton('story_icon', 1),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              iconButton('map_icon', 2),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              iconButton('profile_tab_icon', 3),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(bottom: _fabTopMargin ?? fabBottomMargin),
        child: FloatingActionButton(
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
