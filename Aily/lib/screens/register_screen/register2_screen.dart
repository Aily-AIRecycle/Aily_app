import 'package:aily/class/user_data.dart';
import 'package:aily/screens/register_screen/verification_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../class/urls.dart';

class Register2Screen extends StatefulWidget {
  const Register2Screen({Key? key}) : super(key: key);

  @override
  Register2ScreenState createState() => Register2ScreenState();
}

class Register2ScreenState extends State<Register2Screen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController _nameTextController;
  late TextEditingController _birthdateTextController;
  late TextEditingController _phoneTextController;
  late TextEditingController _nicknameTextController;
  String? _gender = '남성';
  late String usernameChk = "";
  late String nicknameChk = "";
  late String idChk = "";
  late String phoneChk = "";
  late String birthChk = "";
  late Color usernameColor = Colors.red;
  late Color nicknameColor = Colors.red;
  late Color idColor = Colors.red;
  late Color phoneColor = Colors.red;
  late Color birthColor = Colors.red;
  UserData user = UserData();

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _birthdateTextController = TextEditingController();
    _phoneTextController = TextEditingController();
    _nicknameTextController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _birthdateTextController.dispose();
    _phoneTextController.dispose();
    _nicknameTextController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> signUser(String phone, String id, String password, String nickname, String birth, bool awaitData) async {
    final Map<String, dynamic> data = {
      "phonenumber": phone,
      "id": id,
      "password": password,
      "birth": birth,
      "nickname": nickname,
      "profile": "${URL().baseURL}/static/images/default/image.png",
      "await": awaitData
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

  void updateStatus(String key, String value) {
    List<String> parts = value.split(":");
    String chk = parts[0];
    Color color = Color(int.parse(parts[1], radix: 16));

    if (key == "닉네임") {
      nicknameChk = chk;
      nicknameColor = color;
    }
    if (key == "아이디") {
      idChk = chk;
      idColor = color;
    }
    if (key == "전화번호") {
      phoneChk = chk;
      phoneColor = color;
    }
  }

  Future<void> signup() async {
    String username = _nameTextController.text.trim();
    String phone = _phoneTextController.text.trim();
    String nickname = _nicknameTextController.text.trim();
    String birth = _birthdateTextController.text.trim();
    String email = user.email!;
    String password = user.password!;

    if (username.isEmpty) {
      setState(() {
        usernameColor = Colors.red;
        usernameChk = 'ⓘ 이름을 입력해주세요.';
        return;
      });
    } else {
      usernameChk = "";
    }

    if (birth.isEmpty) {
      setState(() {
        birthColor = Colors.red;
        birthChk = 'ⓘ 생년월일을 입력해주세요.';
      });
    }else if (birth.length != 8){
      birthColor = Colors.red;
      birthChk = 'ⓘ 생년월일을 다시 한 번 확인해주세요.';
      return;
    } else{
      birthChk = "";
    }

    if (phone.isEmpty) {
      setState(() {
        phoneColor = Colors.red;
        phoneChk = 'ⓘ 전화번호를 입력해주세요.';
      });
    }else if (phone.length != 11){
      phoneColor = Colors.red;
      phoneChk = 'ⓘ 전화번호를 다시 한 번 확인해주세요.';
      return;
    } else{
      phoneChk = "";
    }

    if (nickname.isEmpty) {
      setState(() {
        nicknameColor = Colors.red;
        nicknameChk = 'ⓘ 닉네임을 입력해주세요.';
        return;
      });
    }else{
      nicknameChk = "";
    }

    if (phone.isEmpty || nickname.isEmpty){
      return;
    }

    try {
      Map<String, dynamic> response = await signUser(phone, email, password, nickname, birth, false);
      final result = response['result'];

      if (result != null) {
        result.forEach((key, value) {
          updateStatus(key, value);
        });
        setState(() {});
      }
    } catch (e) {
      user.phonenumber = int.parse(phone);
      user.nickname = nickname;
      user.birth = birth;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const VerificationScreen()));
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: registerWidget(context),
      )
    );
  }

  Widget registerWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '간단한 정보를 알려주세요.',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.06),
              const Text(
                '이름',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                textInputAction: TextInputAction.done,
                controller: _nameTextController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-zA-Z]{1,8}$')),
                ],
                decoration: InputDecoration(
                  hintText: '홍길동',
                  hintStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(Icons.clear, size: 17, color: Colors.black),
                    onPressed: () {
                      _nameTextController.clear();
                    },
                  ),
                ),
                onEditingComplete: (){
                  signup();
                },
              ),
              Text(
                usernameChk,
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: usernameColor
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.06,
              left: MediaQuery.of(context).size.width * 0.125,
              right: MediaQuery.of(context).size.width * 0.1
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '생년월일',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.375,
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: _birthdateTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,8}$')),
                            ],
                            decoration: InputDecoration(
                              hintText: DateFormat('yyyyMMdd').format(DateTime.now()),
                              hintStyle: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                              ),
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: const Icon(Icons.clear, size: 17, color: Colors.black),
                                onPressed: () {
                                  _birthdateTextController.clear();
                                },
                              ),
                            ),
                            onEditingComplete: (){
                              signup();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '성별',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.375,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _gender = '남성';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Colors.white,
                                    backgroundColor: _gender == '남성' ? Colors.blue : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(
                                        color: Colors.blue, // 원하는 색상으로 변경
                                        width: 0.5, // 테두리 두께
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '남성',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: _gender == '남성' ? Colors.white : Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _gender = '여성';
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Colors.white,
                                    backgroundColor: _gender == '여성' ? myColor : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                        color: myColor, // 원하는 색상으로 변경
                                        width: 0.5, // 테두리 두께
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '여성',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: _gender == '여성' ? Colors.white : myColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      birthChk,
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: birthColor
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '휴대폰 번호',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                controller: _phoneTextController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,11}$')),
                ],
                decoration: InputDecoration(
                  hintText: '전화번호',
                  hintStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(Icons.clear, size: 17, color: Colors.black),
                    onPressed: () {
                      _phoneTextController.clear();
                    },
                  ),
                ),
                onEditingComplete: (){
                  signup();
                },
              ),
              Text(
                phoneChk,
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: phoneColor
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '닉네임',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: _nicknameTextController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|a-zA-Z0-9]{1,8}$')),
                ],
                decoration: InputDecoration(
                  hintText: '8자 이내 한글 혹은 영문',
                  hintStyle: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: const Icon(Icons.clear, size: 17, color: Colors.black),
                    onPressed: () {
                      _nicknameTextController.clear();
                    },
                  ),
                ),
                onEditingComplete: (){
                  FocusScope.of(context).unfocus();
                  signup();
                },
              ),
              Text(
                nicknameChk,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: nicknameColor
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.085),
        ElevatedButton(
          onPressed: () {
            setState(() {
              signup();
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: myColor.withOpacity(0.9),
            backgroundColor: myColor.withOpacity(0.9),
            elevation: 0.9,
            fixedSize: Size(MediaQuery.of(context).size.width * 1.0, MediaQuery.of(context).size.height * 0.07),
          ),
          child: const Text(
            '다음',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}