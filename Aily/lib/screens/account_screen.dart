import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Account_screen extends StatefulWidget {
  const Account_screen({Key? key}) : super(key: key);

  @override
  State<Account_screen> createState() => _Account_screenState();
}



class _Account_screenState extends State<Account_screen> {




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
                                color: Color(0xff767676),
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
                height: 360,
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
                          'assets/images/logout-box-line.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '로그아웃',
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
