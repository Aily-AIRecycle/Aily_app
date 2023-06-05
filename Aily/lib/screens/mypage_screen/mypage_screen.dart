import 'package:aily/screens/mypage_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:aily/screens/login_screen/login_screen.dart';
import 'package:aily/utils/show_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aily/board/faq_screen.dart';
import 'package:aily/board/notice_screen.dart';
import '../../class/user_data.dart';

class Mypagescreen extends StatefulWidget {
  const Mypagescreen({Key? key}) : super(key: key);

  @override
  State<Mypagescreen> createState() => MypagescreenState();
}

class MypagescreenState extends State<Mypagescreen> {
  String? username;
  File? profile;
  UserData user = UserData();
  final storage = const FlutterSecureStorage();

  Future<UserData> _getUser() async {
    UserData user = UserData();
    return user;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void logout(BuildContext context) async {
    imageCache.evict(FileImage(user.profile!));
    await storage.delete(key: 'id');
    await storage.delete(key: 'pw');
    user.nickname = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 72, left: 24, right: 24, bottom: 24),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '마이페이지',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: SvgPicture.asset(
                        //     'assets/images/setting_icon.svg',
                        //     width: 24,
                        //     height: 24,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: ThemeData().copyWith(
                        dividerColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: FutureBuilder<UserData>(
                        future: _getUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserData> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While waiting for the data, you can show a loading indicator
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Handle any errors that occurred during fetching the data
                            return Text('Error: ${snapshot.error}');
                          } else {
                            UserData userData = snapshot.data!;
                            return ListTile(
                              contentPadding: const EdgeInsets.only(left: 0),
                              horizontalTitleGap: 10,
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: IconButton(
                                    onPressed: () {},
                                    splashRadius: 20,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    iconSize: 48,
                                    icon: Image.file(
                                      userData.profile!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                userData.nickname!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: const Text(
                                '프로필 설정',
                                style: TextStyle(
                                  color: Color(0xff767676),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade700,
                                  size: 19,
                                ),
                              ),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {});
                                }
                              },
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width * 0.87,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  width: MediaQuery.of(context).size.width - 48,
                  height: MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xff767676).withOpacity(0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '일상 속 지구를 위한 친환경 실천 !',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Aily와 함께 시작하세요.',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 60,
                            child: SvgPicture.asset(
                                'assets/images/icons/earth.svg'),
                          ),
                          Positioned(
                            top: 30,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: SvgPicture.asset(
                                  'assets/images/icons/hand.svg'),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      padding: const EdgeInsets.fromLTRB(24, 80, 24, 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          listTile(context, 'assets/images/faq_icon.svg',
                              '자주 묻는 질문(FAQ)', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FAQScreen()));
                          }),
                          listTile(
                              context, 'assets/images/notice_icon.svg', '공지사항',
                              () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NoticeScreen()));
                          }),
                          listTile(context, 'assets/images/logout-box-line.svg',
                              '로그아웃', () {
                            logout(context);
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

Widget listTile(
    BuildContext context, String leadingAsset, String title, Function onTap) {
  return Column(
    children: [
      Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ListTile(
          horizontalTitleGap: 0,
          leading: SvgPicture.asset(
            leadingAsset,
            width: 24,
            height: 24,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade700,
            size: 19,
          ),
          onTap: () {
            onTap();
          },
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
