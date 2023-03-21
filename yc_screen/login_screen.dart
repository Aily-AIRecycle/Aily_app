import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter/ShowDialog.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _idController;
  late TextEditingController _passwordController;

  late TextEditingController _signidController;
  late TextEditingController _signpwController;
  late TextEditingController _signpwController2;

  late MySqlConnection conn;
  Color myColor = const Color(0xFFF8B195);
  late Uint8List imgData;
  Uint8List? _downimageData;
  bool _isUploading = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _passwordController = TextEditingController();

    _signidController = TextEditingController();
    _signpwController = TextEditingController();
    _signpwController2 = TextEditingController();

    MySqlConnection.connect(
      ConnectionSettings(
        host: '211.201.93.173',//'175.113.68.69',
        port: 3306,
        user: 'root',
        password: '488799',
        db: 'user_db',
      ),
    ).then((connection) {
      conn = connection;
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();

    _signidController.dispose();
    _signpwController.dispose();
    _signpwController2.dispose();

    conn.close();
    super.dispose();
  }

  Future<void> downloadImageFromServer(String id) async {
    setState(() {
      _isDownloading = true;
    });
    try {
      final result = await conn.query('SELECT image FROM sign WHERE username = ?;', [id]);
      if (result.isNotEmpty) {
        final rowData = result.first;
        final imgData = rowData['image'] as Blob;
        final bytes = imgData.toBytes();
        setState(() {
          _downimageData = bytes as Uint8List?;
        });
      }
      if (_downimageData != null){
        Navigator.pushNamed(context, '/Home', arguments: {
          "phoneNumber": "01012345678",
          "name": id,
          "profile": _downimageData
        });
      }
    } catch (e) {
      showMsg(context, "오류", '다운로드 실패');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> login() async {
    final String id = _idController.text.trim();
    final String pw = _passwordController.text.trim();
    var bytes = utf8.encode(pw); // 문자열을 바이트 배열로 변환
    var md5Result = md5.convert(bytes); // MD5 해시 값 생성
    String md5Password = md5Result.toString();

    // 로그인 처리 로직 구현
    if (id.isEmpty || pw.isEmpty) {
      showMsg(context, "로그인", "아이디 또는 비밀번호를 입력해주세요.");
    } else {
      try {
        final result = await conn.query(
            'SELECT * FROM sign WHERE username = ? AND password = ?', [id, md5Password]);
        if (result.isNotEmpty) {
          downloadImageFromServer(id);
        } else {
          showMsg(context, "로그인", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }
      } catch (e) {
        showMsg(context, "로그인", "오류가 발생했습니다.");
      }
    }
  }

  Future<void> signup() async {
    final String id = _signidController.text.trim();
    final String pw = _signpwController.text.trim();
    final String confirmPw = _signpwController2.text.trim();

    var bytes = utf8.encode(pw); // 문자열을 바이트 배열로 변환
    var md5Result = md5.convert(bytes); // MD5 해시 값 생성
    String md5Password = md5Result.toString();

    try {
      final ByteData imageData = await rootBundle.load('assets/images/default.png');
      imgData = imageData.buffer.asUint8List();
    } catch (e) {
      throw Exception("파일이 존재하지 않습니다.");
    }

    // 회원가입 처리 로직 구현
    if (id.isEmpty || pw.isEmpty || confirmPw.isEmpty) {
      showMsg(context, "회원가입", "아이디 또는 비밀번호를 입력해주세요.");
    } else {
      try {
        if (pw == confirmPw) {
          final result = await conn.query('INSERT INTO sign (username, password, image) VALUES (?, ?, ?)', [id, md5Password, imgData]);
          if (result.affectedRows == 1) {
            _dismissModalBottomSheet();
            showMsg(context, "회원가입", "회원가입 완료");
          }
        } else {
          showMsg(context, "회원가입", "비밀번호가 일치하지 않습니다.");
        }
      } catch (e) {
        if (e is MySqlException && e.errorNumber == 1062) {
          showMsg(context, "회원가입", "중복된 아이디입니다.");
        } else {
          showMsg(context, "회원가입", "오류가 발생했습니다.");
        }
      }
    }
  }

  void _dismissModalBottomSheet() {
    _signidController.clear();
    _signpwController.clear();
    _signpwController2.clear();
    Navigator.of(context).pop();
  }

  void signSheet () {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.6,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 40.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch,
                  children: [
                    const Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _signidController,
                      decoration: const InputDecoration(
                        hintText: '아이디 입력',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _signpwController,
                      decoration: const InputDecoration(
                        hintText: '비밀번호 입력',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _signpwController2,
                      decoration: const InputDecoration(
                        hintText: '비밀번호 확인',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: (){
                        signup();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 248, 177, 149),
                        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 140.0),
                      ),
                      child: const Text('확 인'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                      padding: const EdgeInsets.only(bottom: 10.0),
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
                        width: 200.0,
                        height: 200.0,
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          hintText: '아이디 입력',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: '비밀번호 입력',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: () {
                          signSheet();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: myColor,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13.0, horizontal: 138.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(
                              color: myColor, // 원하는 색상으로 변경
                              width: 2.0, // 테두리 두께
                            ),
                          ),
                        ),
                        child: Text('회원가입', style: TextStyle(color: myColor)),
                      ),
                      const SizedBox(height: 13.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 144.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text('로그인'),
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