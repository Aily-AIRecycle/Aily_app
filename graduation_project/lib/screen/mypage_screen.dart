import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: profileSection(),
    );
  }
}

class profileSection extends StatelessWidget {
  const profileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          SvgPicture.asset(
            'assets/images/borderTop.svg',
            width: 360,
            height: 1,
          ),
          Row(
            children: [
              Expanded(
                /*1*/
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
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
    );
  }
}





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
                    *//*1*//*
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        *//*2*//*
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