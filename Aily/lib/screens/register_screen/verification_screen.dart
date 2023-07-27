import 'dart:async';
import 'package:aily/screens/register_screen/register3_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';
import '../../utils/show_dialog.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController _codeTextController;
  late String emailCode = '';
  bool isCodeSent = false;
  Duration remainingTime = const Duration(minutes: 1);
  Dio dio = Dio();
  UserData user = UserData();

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        remainingTime -= oneSecond; // 1초씩 감소
        if (remainingTime <= Duration.zero) {
          emailCode = 'zzk~!#@28765tj942jgd)__(&&%(*@#';
          timer.cancel();
          isCodeSent = false;
        }
      });
    });
  }

  void sendVerificationCode(useremail) async {
    Response<dynamic> response = await _sendemail(useremail);
    if (response.data != "Failed") {
      emailCode = response.data;
      Future.delayed(Duration.zero, () {
        showMsg(context, "이메일", "메일을 발송했습니다.");
      });

      setState(() {
        isCodeSent = true;
        remainingTime = const Duration(minutes: 3);
      });
      startTimer(); // 타이머 시작
    } else {
      Future.delayed(Duration.zero, () {
        showMsg(context, "이메일", "메일 발송에 실패했습니다.");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _codeTextController = TextEditingController();
  }

  @override
  void dispose() {
    _codeTextController.dispose();
    super.dispose();
  }

  Future<Response<dynamic>> _sendemail(String email) async {
    try {
      Response<dynamic> response = await dio.post(
        URL().authURL,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {'email': email},
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUser(String phone, String id,
      String password, String nickname, String birth) async {
    final Map<String, dynamic> data = {
      "phonenumber": phone,
      "id": id,
      "password": password,
      "birth": birth,
      "nickname": nickname,
      "profile": "${URL().baseURL}/static/images/default/image.png",
      "await": true
    };

    try {
      Dio dio = Dio();
      Response<dynamic> response = await dio.post(
        URL().signURL,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );

      return response.data;
    } catch (error) {
      // Error handling
      rethrow;
    }
  }

  Future<void> signup() async {
    if (_codeTextController.text.trim() == emailCode) {
      showMsg(context, '인증', '이메일 인증에 성공하였습니다 !');
      try {
        await signUser("0${user.phonenumber.toString()}", user.email!,
            user.password!, user.nickname!, user.birth!);
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Register3Screen(),
          ),
        );
      }
    } else {
      showMsg(context, '인증', '인증번호를 다시 한 번 확인해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
          icon: const Icon(Icons.arrow_back_ios, size: 24),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '본인인증',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: verificationWidget(context),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이미 계정이 있으신가요?',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: myColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget verificationWidget(BuildContext context) {
    String useremail = user.email!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          const Text(
            '이메일로 전송된 인증번호를 입력해주세요.',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: useremail,
                        border: const UnderlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                    Positioned(
                      right: 0,
                      child: ElevatedButton(
                        onPressed: isCodeSent
                            ? null
                            : () async {
                                sendVerificationCode(useremail);
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: myColor,
                        ),
                        child: Text(
                          isCodeSent
                              ? '${remainingTime.inMinutes.toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}'
                              : '인증요청',
                        ), // 버튼 텍스트 변경
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextFormField(
                      controller: _codeTextController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '인증번호 입력',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.16),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                signup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
