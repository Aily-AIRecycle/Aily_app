import 'dart:convert';
import 'dart:io';
import 'package:Aily/screens/register_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'manager_screen.dart';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../widgets/Navigator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../class/URLs.dart';
import '../class/UserData.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController idctrl;
  late TextEditingController passwordctrl;

  Color myColor = const Color(0xFFF8B195);
  late Uint8List imgData;
  final storage = const FlutterSecureStorage();
  late int point, phonenumber;
  late String nickname, image;
  late File? profile;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    idctrl = TextEditingController();
    passwordctrl = TextEditingController();

    tryAutoLogin(); //자동 로그인
  }

  @override
  void dispose() {
    idctrl.dispose();
    passwordctrl.dispose();
    super.dispose();
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
        UserData user = UserData();
        user.nickname = nickname;
        user.point = point;
        user.profile = profile;
        user.phonenumber = phonenumber;
      } catch (e) {
        //
      }
      //현재 페이지를 제거 후 페이지 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavigatorScreen()),
            (route) => false,
      );
    } catch (e) {
      //
    }
  }

  Future<void> saveLoginInfo(String id, String pw) async {
    await storage.write(key: 'id', value: id);
    await storage.write(key: 'pw', value: pw);
  }

  Future<void> tryAutoLogin() async {
    final id = await storage.read(key: 'id');
    final pw = await storage.read(key: 'pw');
    try {
      Response<dynamic> response = await loginUser(id!, pw!);
      if (response.statusCode == 200) {
        //로그인 성공
        var jsonResponse = response.data;
        nickname = jsonResponse[0]['nickname'];
        point = jsonResponse[0]['point'];
        image = jsonResponse[0]['profile'];
        phonenumber = jsonResponse[0]['User_phonenumber'];
        if (id == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ManagerScreen()),
                (route) => false,
          );
        } else {
          showLoadingDialog(context);
          downloadImageFromServer(nickname);
        }
      }
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

  Future<void> login() async {
    final String id = idctrl.text.trim();
    final String pw = passwordctrl.text.trim();

    var bytes = utf8.encode(pw); // 문자열을 바이트 배열로 변환
    var sha256Result = sha256.convert(bytes); // MD5 해시 값 생성
    String Password = sha256Result.toString();
    // 로그인 처리 로직 구현
    if (id.isEmpty || pw.isEmpty) {
      showMsg(context, "로그인", "아이디 또는 비밀번호를 입력해주세요.");
    } else {
      try {
        Response<dynamic> response = await loginUser(id, Password);
        if (response.statusCode == 200) {
          //로그인 성공
          var jsonResponse = response.data;
          nickname = jsonResponse[0]['nickname'];
          point = jsonResponse[0]['point'];
          image = jsonResponse[0]['profile'];
          phonenumber = jsonResponse[0]['User_phonenumber'];
          saveLoginInfo(id, Password);
          if (id == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ManagerScreen(),
              ),
            );
          } else {
            showLoadingDialog(context);
            downloadImageFromServer(nickname);
          }
        }else{
          showMsg(context, "로그인", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
      } catch (e) {
        //
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7, bottom: 10.0),
                      child: Text(
                        "Ai Recycling",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Waiting for the Sunrise',
                          fontWeight: FontWeight.bold,
                          color: myColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "AILY",
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Waiting for the Sunrise',
                          fontWeight: FontWeight.bold,
                          color: myColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 225.0,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      const SizedBox(height: 80.0),
                      TextField(
                        controller: idctrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '아이디 입력',
                          hintStyle: const TextStyle(
                            color: Color(0xff969696),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: passwordctrl,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value){
                          login();
                        },
                        decoration: InputDecoration(
                          hintText: '비밀번호 입력',
                          hintStyle: const TextStyle(
                            color: Color(0xff969696),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const registerScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width * 0.9, MediaQuery.of(context).size.height * 0.07),
                          elevation: 0.5,
                          shadowColor: myColor,
                          foregroundColor: myColor,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(
                              color: myColor, // 원하는 색상으로 변경
                              width: 0.5, // 테두리 두께
                            ),
                          ),
                        ),
                        child: Text('회원가입',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: myColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            )),
                      ),
                      const SizedBox(height: 13.0),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor.withOpacity(0.9),
                              elevation: 0,
                              fixedSize: Size(MediaQuery.of(context).size.width * 0.9, MediaQuery.of(context).size.height * 0.07),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 60.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              '로그인',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
