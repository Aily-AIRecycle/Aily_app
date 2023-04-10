import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}



class _MyPageScreenState extends State<MyPageScreen> {

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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(24.0, 72.0, 24.0, 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '프로필',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/setting_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      iconSize: 48,
                      icon: SvgPicture.asset(
                        'assets/images/profile_icon2.svg',
                        width: 48,
                        height: 48,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(
                              '혁진',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: Text(
                              '프로필 설정',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/seagull_icon.svg',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/images/borderTop.svg',
                  width: MediaQuery.of(context).size.width - 33,
                  height: 1,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 63,
            height: MediaQuery.of(context).size.height / 7,
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
          Column(
            children: [
              Container(
                height: 300,
                padding: EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/borderTop.svg',
                      width: MediaQuery.of(context).size.width - 33,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 12),
                        SvgPicture.asset(
                          'assets/images/event_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '이벤트',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/seagull_icon.svg',
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/borderTop.svg',
                      width: MediaQuery.of(context).size.width - 33,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 12),
                        SvgPicture.asset(
                          'assets/images/point_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '포인트',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/seagull_icon.svg',
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/borderTop.svg',
                      width: MediaQuery.of(context).size.width - 33,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 12),
                        SvgPicture.asset(
                          'assets/images/faq_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '자주 묻는 질문(FAQ)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/seagull_icon.svg',
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/borderTop.svg',
                      width: MediaQuery.of(context).size.width - 33,
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 12),
                        SvgPicture.asset(
                          'assets/images/notice_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '공지사항',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/images/seagull_icon.svg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
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

/*Row(
children: [
Expanded(
*/ /*1*/ /*
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
*/ /*2*/ /*
Container(
padding: const EdgeInsets.only(bottom: 8),
child: Text(
'Oeschinen Lake Campground',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),
Text(
'Kandersteg, Switzerland',
style: TextStyle(
color: Colors.grey[500],
),
),
],
),
),
],
),*/

/*SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 72.0, 24.0, 24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '프로필',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/setting_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/profile_icon.svg',
                      width: 48,
                      height: 48,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          '혁진',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Text(
                        '프로필 설정',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,

                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/seagull_icon.svg',
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    */ /*1*/ /*
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        */ /*2*/ /*
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Oeschinen Lake Campground',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Kandersteg, Switzerland',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),*/
