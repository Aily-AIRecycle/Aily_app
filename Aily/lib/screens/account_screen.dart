import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:Aily/screens/login_screen.dart';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Aily/proves/testUserProvider.dart';
import 'package:provider/provider.dart';
import 'package:Aily/board/faq_screen.dart';
import 'package:Aily/board/notice_screen.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Account_screen extends StatefulWidget {
  const Account_screen({Key? key}) : super(key: key);

  @override
  State<Account_screen> createState() => _Account_screenState();
}

class _Account_screenState extends State<Account_screen> {
  late File? _image;
  String? username;
  File? profile;
  final storage = const FlutterSecureStorage();

  Future<void> _getUser() async {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      username = userProvider.user.nickname;
      profile = userProvider.user.image;
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
    await storage.delete(key: 'id');
    await storage.delete(key: 'pw');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    showMsg(context, '로그아웃', '로그아웃 되었습니다.');
  }

  void _profileUpdate(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateImage(_image!);
    profile = userProvider.user.image;
    final cacheManager = DefaultCacheManager();
    await cacheManager.removeFile(profile!.path);
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
      final response = await Dio().post('http://211.201.93.173:8083/api/image', data: formData);

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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24.0, 50.0, 25.0, 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
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
                          icon: Image.file(profile!, width: 48, height: 48, fit: BoxFit.cover)
                      ),
                    ),
                  ),
                  title: Text(username!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                  subtitle: const Text('프로필 설정', style: TextStyle(color: Color(0xff767676), fontSize: 12, fontWeight: FontWeight.w200)),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 19),
                  ),
                  onTap: () {
                    _pickImage(context, ImageSource.gallery);
                  },
                ),

              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height / 7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xffF8B195).withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffF8B195).withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: 360,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/borderTop.svg',
                      width: MediaQuery.of(context).size.width,
                      height: 0,
                    ),
                    ListTile(
                      horizontalTitleGap: 0,
                      leading: SvgPicture.asset(
                        'assets/images/event_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('이벤트', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 19),
                      selectedColor: Colors.red,
                      onTap: () {
                        showMsg(context, '이벤트', '이벤트');
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      horizontalTitleGap: 0,
                      leading: SvgPicture.asset(
                        'assets/images/point_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('포인트', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 19),
                      onTap: () {
                        showMsg(context, '포인트', '포인트');
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      horizontalTitleGap: 0,
                      leading: SvgPicture.asset(
                        'assets/images/faq_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('자주 묻는 질문(FAQ)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 19),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      horizontalTitleGap: 0,
                      leading: SvgPicture.asset(
                        'assets/images/notice_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('공지사항', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 19),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeScreen()));
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      horizontalTitleGap: 0,
                      leading: SvgPicture.asset(
                        'assets/images/logout-box-line.svg',
                        width: 24,
                        height: 24,
                      ),
                      title: const Text('로그아웃', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade700, size: 19),
                      onTap: () {
                        logout(context);
                      },
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