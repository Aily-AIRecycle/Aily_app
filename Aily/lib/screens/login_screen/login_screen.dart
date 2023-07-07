import 'dart:convert';
import 'dart:io';
import 'package:aily/screens/register_screen/register_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import '../manager_screen/manager_screen.dart';
import 'package:aily/utils/show_dialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../navigator_screen/navigator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../class/location.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late TextEditingController idctrl;
  late TextEditingController passwordctrl;

  Color myColor = const Color(0xFFF8B195);
  late Uint8List imgData;
  final storage = const FlutterSecureStorage();
  late int point, phonenumber;
  late String nickname, image, email, birth;
  late File? profile;
  late String savedId;
  bool isIdSaved = false;
  bool isCheckboxChecked = false;
  UserData user = UserData();
  Location location = Location();
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    location.getLocationPermission();
    idctrl = TextEditingController();
    passwordctrl = TextEditingController();
    loadSavedCheckboxState();
    loadSavedId();
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

  // 체크박스 상태 저장하기
  void saveCheckboxState(bool isChecked) async {
    String checkboxState = isChecked ? 'checked' : 'unchecked';
    await storage.write(key: 'checkboxState', value: checkboxState);
  }

  // 체크박스 상태 불러오기
  Future<bool> getCheckboxState() async {
    String? checkboxState = await storage.read(key: 'checkboxState');
    if (checkboxState == 'checked') {
      return true;
    } else {
      return false;
    }
  }

  void loadSavedCheckboxState() async {
    bool isChecked = await getCheckboxState();
    setState(() {
      isCheckboxChecked = isChecked;
      isIdSaved = isChecked; // 체크박스 상태를 아이디 저장 변수에도 반영합니다.
    });
  }

  Future<void> savedInfo(String id, String pw) async {
    await storage.write(key: 'id', value: id);
    await storage.write(key: 'pw', value: pw);
  }

  void saveId(String id) async {
    await storage.write(key: 'savedId', value: id);
  }

  Future<String?> getSavedId() async {
    return await storage.read(key: 'savedId');
  }

  void loadSavedId() async {
    String? id = await getSavedId();
    setState(() {
      savedId = id!;
      if (savedId.isNotEmpty) {}
      idctrl.text = savedId;
    });
  }

  void deleteSavedId() async {
    await storage.delete(key: 'savedId');
  }

  Future<void> tryAutoLogin() async {
    final id = await storage.read(key: 'id');
    final pw = await storage.read(key: 'pw');
    try {
      Response<dynamic> response = await loginUser(id!, pw!);
      if (response.statusCode == 200) {
        //로그인 성공
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
          Future.delayed(Duration.zero, () {
            showLoadingDialog(context);
          });
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

    var bytes = utf8.encode(pw);
    var sha256Result = sha256.convert(bytes);
    String password = sha256Result.toString();
    // 로그인 처리 로직 구현
    if (id.isEmpty || pw.isEmpty) {
      showMsg(context, "로그인", "아이디 또는 비밀번호를 입력해주세요.");
    } else {
      try {
        Response<dynamic> response = await loginUser(id, password);
        if (response.statusCode == 200) {
          //로그인 성공
          var jsonResponse = response.data;
          email = jsonResponse[0]['id'];
          birth = jsonResponse[0]["birth"];
          nickname = jsonResponse[0]['nickname'];
          point = jsonResponse[0]['point'];
          image = jsonResponse[0]['profile'];
          phonenumber = jsonResponse[0]['User_phonenumber'];

          savedInfo(id, password);
          if (id == 'admin') {
            user.nickname = nickname;
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManagerScreen(),
                ),
              );
            });
          } else {
            Future.delayed(Duration.zero, () {
              showLoadingDialog(context);
            });
            downloadImageFromServer(nickname);
          }
        }
      } catch (e) {
        showMsg(context, "로그인", "아이디 또는 비밀번호가 올바르지 않습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.13),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7, bottom: 10.0),
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: 300.0,
                          height: MediaQuery.of(context).size.height * 0.23,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ai Recycling",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Waiting for the Sunrise',
                            fontWeight: FontWeight.bold,
                            color: myColor,
                          ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: passwordctrl,
                          textInputAction: TextInputAction.go,
                          onSubmitted: (value) {
                            login();
                          },
                          decoration: InputDecoration(
                            hintText: '비밀번호 입력',
                            hintStyle: const TextStyle(
                              color: Color(0xff969696),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          obscureText: true,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isCheckboxChecked,
                              checkColor: Colors.white,
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return myColor;
                                  }
                                  return Colors.black;
                                },
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckboxChecked = value!;
                                  isIdSaved = value; // 체크박스 상태를 아이디 저장 변수에 반영
                                  saveCheckboxState(value); // 체크박스 상태를 저장
                                  if (isIdSaved) {
                                    final String id = idctrl.text.trim();
                                    saveId(id);
                                  } else {
                                    deleteSavedId();
                                  }
                                });
                              },
                            ),
                            const Text("아이디 저장"),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.9,
                                MediaQuery.of(context).size.height * 0.07),
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
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: myColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
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
        ],
      ),
    );
  }
}
