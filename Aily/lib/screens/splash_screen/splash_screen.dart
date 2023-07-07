import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';
import '../login_screen/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import '../manager_screen/manager_screen.dart';
import '../navigator_screen/navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Color myColor = const Color(0xFFF8B195);
  final storage = const FlutterSecureStorage();
  late int point, phonenumber;
  late String nickname, image, email, birth;
  late File? profile;
  UserData user = UserData();
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    stroageChk();
  }

  Future<void> downloadImageFromServer(String nickname) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profile.png';
      final profileFile = File(imagePath);

      try {
        Response response = await dio.get(
          image,
          options: Options(responseType: ResponseType.bytes),
        );

        if (await profileFile.exists()) {
          await profileFile.delete();
        }
        await profileFile.writeAsBytes(response.data, flush: true);
        setState(() {
          profile = profileFile;
        });
        user.email = email;
        user.birth = birth;
        user.nickname = nickname;
        user.point = point;
        user.profile = profile;
        user.phonenumber = phonenumber;
      } catch (e) {
        //
      }
      //현재 페이지를 제거 후 페이지 이동
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NavigatorScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      //
    }
  }

  Future<Response<dynamic>> loginUser(String id, String password) async {
    try {
      Response<dynamic> response = await dio.post(
        URL().loginURL,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'id': id,
          'password': password,
        },
      );

      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> stroageChk() async {
    final id = await storage.read(key: 'id');
    final pw = await storage.read(key: 'pw');
    if (id != null && pw != null && id.isNotEmpty && pw.isNotEmpty) {
      try {
        Response<dynamic> response = await loginUser(id, pw);
        if (response.statusCode == 200) {
          // 로그인 성공
          var jsonResponse = response.data;
          email = jsonResponse[0]['id'];
          birth = jsonResponse[0]["birth"];
          nickname = jsonResponse[0]['nickname'];
          point = jsonResponse[0]['point'];
          image = jsonResponse[0]['profile'];
          phonenumber = jsonResponse[0]['User_phonenumber'];
          if (id == 'admin') {
            user.nickname = nickname;
            Future.delayed(Duration.zero, () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ManagerScreen()),
                (route) => false,
              );
            });
          } else {
            downloadImageFromServer(nickname);
          }
        }
      } catch (e) {
        // 오류 처리
      }
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.2;
    double imageHeight = MediaQuery.of(context).size.height * 0.2;

    return Center(
      child: SvgPicture.asset(
        'assets/images/logo.svg',
        width: imageWidth, // 이미지 크기
        height: imageHeight,
      ),
    );
  }
}
