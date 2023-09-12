import 'package:aily/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';

class EditnameScreen extends StatefulWidget {
  const EditnameScreen({Key? key}) : super(key: key);

  @override
  EditnameScreenState createState() => EditnameScreenState();
}

class EditnameScreenState extends State<EditnameScreen> {
  Color myColor = const Color(0xFFF8B195);
  String? username, searchStr;
  late TextEditingController searchctrl;
  final FocusNode _searchFocusNode = FocusNode();
  UserData user = UserData();
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    searchctrl = TextEditingController();
    searchctrl.text = user.nickname!;
  }

  @override
  void dispose() {
    searchctrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<Response<dynamic>> namechk(String name) async {
    try {
      Response<dynamic> response = await dio.get(
        "${URL().namechkURL}/$name",
      );

      return response;

    } catch (error) {
      rethrow;
    }
  }

  Future<void> namechange() async {
    final String name = searchctrl.text.trim();

    try {
      Response<dynamic> response = await namechk(name);
      if (response.statusCode == 200) {
        //로그인 성공
        var jsonResponse = response.data;
        if (jsonResponse == "yes"){
          //showMsg(context, jsonResponse, '사용 가능합니다.');
          user.nickname = name;
          Future.delayed(Duration.zero, () {
            Navigator.pop(context, name);
            showMsg(context, name, '이름이 변경되었습니다.');
          });
        } else{
          showMsg(context, jsonResponse, '사용중인 이름입니다.');
        }
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('이름 변경', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                focusNode: _searchFocusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  setState(() {

                  });
                },
                style: const TextStyle(color: Colors.black),
                controller: searchctrl,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: myColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                namechange();
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
                '확인',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        )

      ),
    );
  }
}