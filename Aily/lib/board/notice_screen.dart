import 'package:flutter/material.dart';

class NoticeScreen extends StatefulWidget {

  const NoticeScreen({Key? key}) : super(key: key);

  @override
  NoticeScreenState createState() => NoticeScreenState();
  }

  class NoticeScreenState extends State<NoticeScreen> with TickerProviderStateMixin {

  Color myColor = const Color(0xFFF8B195);

  final List<Map<String, String>> noticeList = [
    {
      'title': '[공지] 05/01 근로자의 날 고객센터 휴무 안내',
      'content':
      '안녕하세요.\n'
          '대한민국 자원순환체계를 선도하고 있는 소셜벤처, Aily입니다.\n'
          '\n''5월 1일 월요일은 근로자의 날로, Aily 고객센터가 휴무할 예정입니다.\n'
          'Aily 회수 및 점검서비스는 평일과 동일하게 진행될 예정이오니 참고 부탁드리겠습니다.'
    },
    {'title': '[공지] 04/28(금) 임시 휴무 안내', 'content': '04/28(금) 임시 휴무 안내'},
    {'title': '[공지] Aily 모바일 앱 출시 안내', 'content': 'Aily 모바일 앱 출시 안내'},
    {'title': '[공지] Aily 서비스 개편 안내', 'content': 'Aily 서비스 개편 안내'},
    {'title': '[공지] 시스템 점검 완료(05/02)', 'content': '시스템 점검 완료(05/02)'},
    {'title': '[공지] Aily 이용약관 개정 안내', 'content': 'Aily 이용약관 개정 안내'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('공지사항', style: TextStyle(fontSize: 17, color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: noticeList.length,
                itemBuilder: (BuildContext context, int index) {
                  final faq = noticeList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        listTile(context, faq['title']!, faq['content']!)
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}

Widget listTile(BuildContext context, String title, String content) {
  return Column(
    children: [
      Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent
        ),
        child: ExpansionTile(
          textColor: Colors.black,
          iconColor: Colors.grey.shade600,
          title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade100,
              child: Text(content, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
      Container(
        height: 0.5,
        width: MediaQuery.of(context).size.width * 0.87,
        color: Colors.grey.shade400,
      ),
    ],
  );
}