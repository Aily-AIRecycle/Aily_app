import 'package:flutter/material.dart';
import 'verification_screen.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);

  @override
  _registerScreenState createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  Color myColor = const Color(0xFFF8B195);

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
      body: RegisterWidget(context),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
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

  Widget RegisterWidget(BuildContext context) {
    String? dropdownValue = '직접입력';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            '회원가입',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Text(
            '아이디',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                margin: const EdgeInsets.only(right: 4),
                child: TextField(
                  decoration: InputDecoration(
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
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                  '@',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 4),
                width: MediaQuery.of(context).size.width * 0.4,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
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
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['naver.com', 'gmail.com', '직접입력']
                      .map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Text(
            '비밀번호',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextField(
            decoration: InputDecoration(
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
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          TextField(
            decoration: InputDecoration(
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
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const verificationScreen()));
              },
              child: Text(
                '다음',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColor.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
