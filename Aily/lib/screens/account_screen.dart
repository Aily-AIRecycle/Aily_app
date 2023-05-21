import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:Aily/screens/login_screen.dart';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Aily/board/faq_screen.dart';
import 'package:Aily/board/notice_screen.dart';
import '../class/URLs.dart';
import '../class/UserData.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Account_screen extends StatefulWidget {
  const Account_screen({Key? key}) : super(key: key);

  @override
  State<Account_screen> createState() => _Account_screenState();
}

class _Account_screenState extends State<Account_screen> {
  late File? _image;
  String? username;
  File? profile;
  UserData user = UserData();
  final storage = const FlutterSecureStorage();

  Future<void> _getUser() async {
    UserData user = UserData();
    setState(() {
      username = user.nickname;
      profile = user.profile;
    });
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
    imageCache.evict(FileImage(profile!));
    await storage.delete(key: 'id');
    await storage.delete(key: 'pw');
    setState(() {
      user.nickname = '';
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    showMsg(context, '로그아웃', '로그아웃 되었습니다.');
  }

  void _profileUpdate(BuildContext context) async {
    UserData user = UserData();
    user.profile = _image;
    profile = user.profile;
    setState(() {});
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _profileUpdate(context);
      await _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File file) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'file': await MultipartFile.fromFile(file.path, filename: 'image.png'),
      });
      final response = await Dio().post(URL().imageURL, data: formData);

      if (response.statusCode == 200) {
        //
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 72, left: 24, right: 24, bottom: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '마이페이지',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: const EdgeInsets.only(left: 0),
                      horizontalTitleGap: 10,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: IconButton(
                              onPressed: () {
                                showMsg(context, '프로필', '프로필');
                              },
                              splashRadius: 20,
                              color: Colors.transparent,
                              padding: EdgeInsets.zero,
                              iconSize: 48,
                              icon: Image.file(profile!,
                                  width: 48, height: 48, fit: BoxFit.cover)),
                        ),
                      ),
                      title: Text(username!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      subtitle: const Text('프로필 설정',
                          style: TextStyle(
                              color: Color(0xff767676),
                              fontSize: 12,
                              fontWeight: FontWeight.w400)
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(Icons.arrow_forward_ios,
                            color: Colors.grey.shade700, size: 19),
                      ),
                      onTap: () {
                        _pickImage(context, ImageSource.gallery);
                      },
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
                    color: Color(0xff767676).withOpacity(0.25),
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
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const Text('Aily와 함께 시작하세요.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 60,
                          child: SvgPicture.asset('assets/images/icons/earth.svg'),
                        ),
                        Positioned(
                          top: 30,
                          child:SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset('assets/images/icons/hand.svg'),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ListTile(context, 'assets/images/faq_icon.svg',
                              '자주 묻는 질문(FAQ)', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FAQScreen()));
                          }),
                          _ListTile(context, 'assets/images/notice_icon.svg',
                              '공지사항', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NoticeScreen()));
                          }),
                          _ListTile(
                              context,
                              'assets/images/logout-box-line.svg',
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
        )
    );
  }
}

Widget _ListTile(
    BuildContext context, String leadingAsset, String title, Function onTap) {
  final InteractiveInkFeatureFactory splashFactory;

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
