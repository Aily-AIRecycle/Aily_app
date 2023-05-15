import 'package:flutter/material.dart';

class verificationScreen extends StatefulWidget {
  const verificationScreen({Key? key}) : super(key: key);

  @override
  _verificationScreenState createState() => _verificationScreenState();
}

class _verificationScreenState extends State<verificationScreen> {
  Color myColor = const Color(0xFFF8B195);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        // leading: IconButton(
        //   padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
        //   icon: const Icon(Icons.arrow_back_ios, size: 24),
        //   splashColor: Colors.transparent,
        //   highlightColor: Colors.transparent,
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text(
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
      body: VerificationWidget(context),
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

  Widget VerificationWidget(BuildContext context) {
    String? dropdownValue = '직접입력';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Text(
            '이메일로 전송된 인증번호를 입력해주세요',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '인증번호 입력',
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


            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
