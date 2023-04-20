import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/my_button/default_containerstyle.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
    ),
    Text(
      'Messages',
    ),
    SizedBox.shrink(),
    Text(
      'Notifications',
    ),
    Text(
      'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // TODO: Add your QR code functionality here
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(24.0, 72.0, 24.0, 20.0),
              color: Colors.orange,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container( // 검색창 컨테이너
                    width: MediaQuery.of(context).size.width - 63,
                    height: MediaQuery.of(context).size.height / 16,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          '주소 지역 등 검색',
                          style: TextStyle(
                            color: Color(0xff989898),
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xff767676).withOpacity(0.25),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff767676).withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  Text('현 위치에서 가까운 Aily의 위치가 나타나요'),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                color: Colors.green,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 63,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xffF8B195).withOpacity(0.25),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffF8B195).withOpacity(0.1),
                            blurRadius: 30,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 63,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xffF8B195).withOpacity(0.25),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffF8B195).withOpacity(0.1),
                            blurRadius: 30,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          // height: 60,
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 20.0),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/home_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                  ),
                  Text(
                    '홈',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      color: Color(0xff767676),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/story_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _onItemTapped(1);
                    },
                  ),
                  Text(
                    '스토리',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      color: Color(0xff767676),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 100.0),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/map_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _onItemTapped(3);
                    },
                  ),
                  Text(
                    '지도',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      color: Color(0xff767676),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0),
              Column(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/profile_tab_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      _onItemTapped(4);
                    },
                  ),
                  Text(
                    '프로필',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      color: Color(0xff767676),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(2);
        },
        child: Icon(Icons.qr_code, size: 40.0),
        backgroundColor: Color(0xFFF8B195),
        foregroundColor: Colors.white,
        elevation: 5.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
