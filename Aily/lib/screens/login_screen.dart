import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'manager_screen.dart';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../widgets/Navigator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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
  late TextEditingController signidctrl;
  late TextEditingController signpwctrl;
  late TextEditingController signpwctrl2;
  late TextEditingController signphonectrl;
  late TextEditingController signnicknamectrl;

  Color myColor = const Color(0xFFF8B195);
  late Uint8List imgData;
  final storage = const FlutterSecureStorage();
  late int point, phonenumber;
  late String nickname, image;
  late File? profile;
  late DateTime selectedDate;
  String? _selectedGender;
  final List<String> _genders = ['남', '여'];
  String? _birth;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;

  @override
  void initState() {
    super.initState();
    idctrl = TextEditingController();
    passwordctrl = TextEditingController();

    signidctrl = TextEditingController();
    signpwctrl = TextEditingController();
    signpwctrl2 = TextEditingController();
    signphonectrl = TextEditingController();
    signnicknamectrl = TextEditingController();
    selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    _selectedGender = '남';
    _birth = selectedDate.toString();
    tryAutoLogin(); //자동 로그인
  }

  @override
  void dispose() {
    idctrl.dispose();
    passwordctrl.dispose();
    signidctrl.dispose();
    signpwctrl.dispose();
    signpwctrl2.dispose();
    signphonectrl.dispose();
    signnicknamectrl.dispose();
    super.dispose();
  }

  Future<void> downloadImageFromServer(String nickname) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profile.png';
      final profileFile = File(imagePath);

      try {
        final response = await http.get(Uri.parse(image));

        if (await profileFile.exists()) {
          await profileFile.delete();
        }
        await profileFile.writeAsBytes(response.bodyBytes,
            mode: FileMode.write);
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
      http.Response response = await loginUser(id!, pw!);
      if (response.statusCode == 200) {
        //로그인 성공
        var jsonResponse = jsonDecode(response.body);
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

  Future<http.Response> loginUser(String id, String password) async {
    final response =
    await http.post(Uri.parse(URL().loginURL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'password': password,
        }));
    return response;
  }

  Future<void> login() async {
    final String id = idctrl.text.trim();
    final String pw = passwordctrl.text.trim();

    var bytes = utf8.encode(pw); // 문자열을 바이트 배열로 변환
    var md5Result = md5.convert(bytes); // MD5 해시 값 생성
    String md5Password = md5Result.toString();
    // 로그인 처리 로직 구현
    if (id.isEmpty || pw.isEmpty) {
      showMsg(context, "로그인", "아이디 또는 비밀번호를 입력해주세요.");
    } else {
      try {
        http.Response response = await loginUser(id, md5Password);
        if (response.statusCode == 200) {
          //로그인 성공
          var jsonResponse = jsonDecode(response.body);
          nickname = jsonResponse[0]['nickname'];
          point = jsonResponse[0]['point'];
          image = jsonResponse[0]['profile'];
          phonenumber = jsonResponse[0]['User_phonenumber'];
          saveLoginInfo(id, md5Password);
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

  Future<http.Response> signUser(
      String phone, String id, password, nickname, birth) async {
    final Map<String, dynamic> data = {
      "phonenumber": phone,
      "id": id,
      "password": password,
      "birth": birth,
      "nickname": nickname,
      "profile": "${URL().baseURL}/static/images/default/image.png"
    };

    final response = await http.post(
      Uri.parse(URL().signURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  Future<void> signup() async {
    final String id = signidctrl.text.trim();
    final String pw = signpwctrl.text.trim();
    final String confirmPw = signpwctrl2.text.trim();
    final String phone = signphonectrl.text.trim();
    final String nickname = signnicknamectrl.text.trim();

    var bytes = utf8.encode(pw); // 문자열을 바이트 배열로 변환
    var md5Result = md5.convert(bytes); // MD5 해시 값 생성
    String md5Password = md5Result.toString();

    // 회원가입 처리 로직 구현
    if (id.contains(' ') || pw.contains(' ')) {
      showMsg(context, "회원가입", "아이디 또는 비밀번호에 공백이 포함되어 있습니다.");
    } else if (id.isEmpty || pw.isEmpty || confirmPw.isEmpty) {
      showMsg(context, "회원가입", "아이디 또는 비밀번호를 입력해주세요.");
    } else {
      if (pw == confirmPw) {
        try {
          http.Response response =
              await signUser(phone, id, md5Password, nickname, _birth);
          final responsebody = json.decode(utf8.decode(response.bodyBytes));
          final error = responsebody['error'];
          if (error == '중복된 닉네임입니다.') {
            showMsg(context, "회원가입", "중복된 닉네임입니다.");
          } else if (error == '중복된 전화번호입니다.') {
            showMsg(context, "회원가입", "중복된 전화번호입니다.");
          }
        } catch (e) {
          _dismissModalBottomSheet();
          showMsg(context, "회원가입", "회원가입 완료");
        }
      } else {
        showMsg(context, "회원가입", "비밀번호가 일치하지 않습니다.");
      }
    }
  }

  void _dismissModalBottomSheet() {
    signidctrl.clear();
    signpwctrl.clear();
    signpwctrl2.clear();
    signphonectrl.clear();
    signnicknamectrl.clear();
    Navigator.of(context).pop();
  }

  void _updateSelectedYear(int? year) {
    setState(() {
      selectedYear = year ?? DateTime.now().year;
      selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);

      // 해당 월의 마지막 일자를 계산하여 일자수를 업데이트합니다.
      int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
      if (selectedDay > daysInMonth) {
        selectedDay = daysInMonth;
        selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
        _updateBirth();
      }
    });
  }

  void _updateSelectedMonth(int? month) {
    setState(() {
      selectedMonth = month ?? DateTime.now().month;
      selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);

      // 해당 월의 마지막 일자를 계산하여 일자수를 업데이트합니다.
      int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
      if (selectedDay > daysInMonth) {
        selectedDay = daysInMonth;
        selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
        _updateBirth();
      }
    });
  }

  void _updateSelectedDay(int? day) {
    setState(() {
      selectedDay = day ?? DateTime.now().day;
      selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
      _updateBirth();
    });
  }

  void _updateSelectedGender(String? gender) {
    setState(() {
      _selectedGender = gender!;
    });
  }

  void _updateBirth() {
    if (selectedYear.isNaN || selectedMonth.isNaN || selectedDay.isNaN) {

    } else {
      _birth =
          '$selectedYear-${selectedMonth.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}';
    }
  }

  Widget buildTextFormField(String hintText, TextEditingController controller,
      TextInputType keyboardType, bool obscure) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        border: const UnderlineInputBorder(),
      ),
      obscureText: obscure,
    );
  }

  Widget buildDropdownButtonFormField<T>(
      List<DropdownMenuItem<T>> items,
      T value,
      Function(T?) onChanged,
      InputDecoration decoration,
      double width,
      double height) {
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonFormField<T>(
        decoration: decoration,
        value: value,
        items: items,
        onChanged: onChanged,
        menuMaxHeight: 250,
      ),
    );
  }

  Future<void> signSheet() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    buildTextFormField(
                        '이메일 입력', signidctrl, TextInputType.text, false),
                    buildTextFormField('비밀번호 입력', signpwctrl,
                        TextInputType.visiblePassword, true),
                    buildTextFormField('비밀번호 확인', signpwctrl2,
                        TextInputType.visiblePassword, true),
                    const SizedBox(height: 20.0),
                    const Text('생년월일'),
                    Row(
                      children: [
                        SizedBox(
                          width: 70,
                          height: 50,
                          child: Expanded(
                            child: buildDropdownButtonFormField<int>(
                                List.generate(
                                  100,
                                  (index) => DropdownMenuItem<int>(
                                    value: DateTime.now().year - index,
                                    child: Text(
                                      '${DateTime.now().year - index}',
                                    ),
                                  ),
                                ),
                                selectedYear,
                                _updateSelectedYear,
                                const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                                70,
                                50),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                          width: 70,
                          height: 50,
                          child: Expanded(
                            child: buildDropdownButtonFormField<int>(
                                List.generate(
                                  12,
                                  (index) => DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text(
                                      '${index + 1}월',
                                    ),
                                  ),
                                ),
                                selectedMonth,
                                _updateSelectedMonth,
                                const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                                70,
                                50),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                          width: 70,
                          height: 50,
                          child: Expanded(
                            child: buildDropdownButtonFormField<int>(
                                List.generate(
                                  31,
                                  (index) => DropdownMenuItem<int>(
                                    value: index + 1,
                                    child: Text(
                                      '${index + 1}일',
                                    ),
                                  ),
                                ),
                                selectedDay,
                                _updateSelectedDay,
                                const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                                70,
                                50),
                          ),
                        ),
                        const SizedBox(width: 50.0),
                        SizedBox(
                          width: 70,
                          height: 50,
                          child: buildDropdownButtonFormField<String>(
                            _genders.map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Row(
                                  children: [
                                    gender == '남'
                                        ? const Icon(Icons.man,
                                            color: Colors.blue)
                                        : const Icon(Icons.woman,
                                            color: Colors.red),
                                    Text(gender)
                                  ],
                                ),
                              );
                            }).toList(),
                            _selectedGender!,
                            _updateSelectedGender,
                            const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            70,
                            50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    buildTextFormField(
                        '이름', signnicknamectrl, TextInputType.text, false),
                    buildTextFormField(
                        '전화번호 입력', signphonectrl, TextInputType.phone, false),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        await signup();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 248, 177, 149),
                        padding: const EdgeInsets.symmetric(
                            vertical: 13.0, horizontal: 140.0),
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
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '아이디 입력',
                          hintStyle: TextStyle(
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
                          signSheet();
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
