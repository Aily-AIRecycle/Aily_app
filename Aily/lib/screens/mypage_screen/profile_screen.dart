import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Color myColor = const Color(0xFFF8B195);
  late File? _image;
  String? email, username, phonemumber, birth;
  File? profile;
  UserData user = UserData();
  final storage = const FlutterSecureStorage();

  Future<void> _getUser() async {
    UserData user = UserData();
    setState(() {
      email = user.email;
      username = user.nickname;
      phonemumber = "0${user.phonenumber.toString()}";
      //profile = user.profile;
      _image = user.profile;
      DateTime dateTime =
          DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'").parseUtc(user.birth!);
      birth = DateFormat("yyyy-MM-dd").format(dateTime);
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
    }
  }

  Future<void> _updateInfo() async {
    _profileUpdate(context);
    await _uploadImage(_image!);
    Future.delayed(Duration.zero, () {
      Navigator.pop(context, profile);
    });
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text('프로필 편집',
              style: TextStyle(fontSize: 17, color: Colors.black)),
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
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.file(_image!,
                                  width: 200, height: 200, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height * 0.245,
                            left: MediaQuery.of(context).size.width * 0.252,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _pickImage(context, ImageSource.gallery);
                                  },
                                  child: const Text('EDIT',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500)),
                                ))),
                      ],
                    ),
                    Text(username!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 12.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(email!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: 0.5,
                      width: MediaQuery.of(context).size.width * 0.87,
                      color: Colors.grey.shade300,
                    ),
                    Theme(
                        data: ThemeData().copyWith(
                          dividerColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            buildListTile(username!, '이름', 70.0, Icons.edit_off,
                                Colors.grey, () {}),
                            buildListTile("남자", '성별', 70.0, Icons.edit,
                                Colors.black, () {}),
                            buildListTile(phonemumber!, '연락처', 65.0,
                                Icons.edit_off, Colors.grey, () {}),
                            buildListTile(birth!, '생년월일', 50.0, Icons.edit,
                                Colors.black, () {}),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.06),
                            ElevatedButton(
                              onPressed: () {
                                //수정된 데이터 저장
                                _updateInfo();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: myColor.withOpacity(0.7),
                                elevation: 0,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    MediaQuery.of(context).size.height * 0.07),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                '저장',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

Widget buildListTile(String title, String leadingText, double titleGap,
    IconData trailingIcon, Color iconColor, Function()? onTap) {
  return ListTile(
    contentPadding: const EdgeInsets.only(left: 40),
    horizontalTitleGap: titleGap,
    leading: Text(
      leadingText,
      style: const TextStyle(
          fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400),
    ),
    title: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    trailing: Padding(
      padding: const EdgeInsets.only(right: 40),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          trailingIcon,
          color: iconColor,
          size: 19,
        ),
      ),
    ),
  );
}
