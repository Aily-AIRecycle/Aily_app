import 'dart:convert';
import 'package:aily/class/user_data.dart';
import 'package:aily/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'register2_screen.dart';
import 'package:crypto/crypto.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  Color myColor = const Color(0xFFF8B195);
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _domainController = TextEditingController();
  late final TextEditingController _password1Controller = TextEditingController();
  late final TextEditingController _password2Controller = TextEditingController();
  UserData user = UserData();

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

  PopupMenuButton<String> buildPopupMenuButton(TextEditingController controller) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          buildPopupMenuItem('naver.com'),
          buildPopupMenuItem('gmail.com'),
          buildPopupMenuItem('daum.net'),
          buildPopupMenuItem('hanmail.net'),
          buildPopupMenuItem('nate.com'),
          buildPopupMenuItem(''),
        ];
      },
      onSelected: (String value) {
        setState(() {
          controller.text = value;
        });
      },
      child: const Icon(Icons.keyboard_arrow_down_outlined, size: 24, color: Colors.grey),
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value.isEmpty ? '직접입력' : value,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  void _nextpage() {
    String email     = _emailController.text.trim();
    String domain    = _domainController.text.trim();
    String password1 = _password1Controller.text.trim();
    String password2 = _password2Controller.text.trim();

    if (email.isEmpty || !RegExp(r'^[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$').hasMatch(domain)){
      showMsg(context, '회원가입', '이메일 형식이 올바르지 않습니다.');
      return;
    }

    if (password1.length < 8 ||
        !RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]+$')
            .hasMatch(password1)) {
      showMsg(context, '회원가입', '영문, 숫자, 특수문자 조합 8글자 이상을 입력해주세요.');
      return;
    } else if (password1 == password2){
      //성공
      user.email = '$email@$domain';
      user.password = sha256.convert(utf8.encode(password2)).toString();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Register2Screen()));
    }else{
      showMsg(context, '회원가입', '비밀번호를 다시 한 번 확인해주세요.');
    }
  }

  Widget registerWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          const Text(
            '회원가입',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          const Text(
            '아이디',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                margin: const EdgeInsets.only(right: 4),
                child: TextField(
                  controller: _emailController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: '이메일',
                    hintStyle: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: const Text(
                  '@',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.015),
              Expanded(
                child: Stack(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: '직접입력',
                        hintStyle: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                      ),
                      controller: _domainController,
                      enabled: _domainController.text == '',
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.016,
                      right: 0,
                      child: buildPopupMenuButton(_domainController),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          const Text(
            '비밀번호',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextField(
            controller: _password1Controller,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: '영문, 숫자, 특수문자 조합 8글자 이상',
              hintStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            obscureText: true,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextField(
            controller: _password2Controller,
            decoration: const InputDecoration(
              hintText: '비밀번호 재입력',
              hintStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            onEditingComplete: (){
              _nextpage();
            },
            obscureText: true,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                _nextpage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '다음',
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