import 'dart:async';
import 'package:aily/screens/dictionary_screen/dictcontents_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../class/urls.dart';
import 'package:dio/dio.dart';

class DictionaryScreen extends StatefulWidget {
  final String title;
  final int type;

  const DictionaryScreen({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  DictionaryScreenState createState() => DictionaryScreenState();
}

class DictionaryScreenState extends State<DictionaryScreen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  String searchStr = '';
  String name = '';
  bool status = false;
  Dio dio = Dio();
  final FocusNode _searchFocusNode = FocusNode();
  late List<Map<String, dynamic>> dataList = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    searchctrl = TextEditingController();
    timer = Timer.periodic(
        const Duration(milliseconds: 100), (timer) => dict(widget.type));
  }

  @override
  void dispose() {
    searchctrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void dict(int type) async {
    try {
      Response response = await dio.post(
        URL().typeURL,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'type': type,
        },
      );
      if (response.statusCode == 200) {
        timer?.cancel();
        setState(() {
          dataList = List<Map<String, dynamic>>.from(response.data);
        });
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text('재활용 사전', style: TextStyle(color: Colors.black)),
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
          body: dictionaryWidget(context),
        ),
      ),
    );
  }

  Widget dictionaryWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.title} 분리배출',
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          focusNode: _searchFocusNode,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            setState(() {
                              searchStr = value;
                            });
                          },
                          style: TextStyle(color: Colors.grey.shade600),
                          controller: searchctrl,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            hintText: "물품 검색",
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
                            prefixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchStr = searchctrl.text;
                                  _searchFocusNode.unfocus();
                                });
                              },
                              child: SvgPicture.asset(
                                  'assets/images/icons/search.svg'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 48,
                        height: MediaQuery.of(context).size.height * 0.61,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '검색한 물품의 재활용 여부가 나타나요.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            const SizedBox(height: 30),
                            _buildListTiles(),
                          ],
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
    );
  }

  Widget _buildListTiles() {
    List<Widget> listTiles = [];

    // dataList에서 검색어에 맞는 데이터만 필터링하여 리스트에 추가
    final filteredList =
        dataList.where((data) => data['name'].contains(searchStr)).toList();

    for (final data in filteredList) {
      final int number = data['number'];
      final String name = data['name'];
      final String contents = data['contents'];

      // number 값의 맨 끝 자리 숫자를 이용하여 재활용 가능 여부확인
      final lastDigit = number % 10;
      final status = lastDigit == 1;

      listTiles.add(
        listTile(context, name, widget.title, status, contents),
      );
    }
    return Expanded(
      child: SingleChildScrollView(child: Column(children: listTiles)),
    );
  }
}

Widget listTile(BuildContext context, String title, test1, bool isAvailable,
    String contents) {
  Color myColor = const Color(0xFFF8B195);

  return Column(
    children: [
      Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: myColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Theme(
          data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent),
          child: ListTile(
            horizontalTitleGap: 0,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            leading: const Icon(Icons.restore_from_trash, color: Colors.black),
            title: Text(title,
                style: const TextStyle(fontSize: 18, color: Colors.black)),
            subtitle: Text(test1,
                style: const TextStyle(fontSize: 13, color: Colors.grey)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '재활용',
                      style: TextStyle(fontSize: 12, color: Color(0xff989898)),
                    ),
                    const SizedBox(height: 5),
                    isAvailable
                        ? const Icon(Icons.circle,
                            color: Colors.lightGreenAccent, size: 14)
                        : const Icon(Icons.circle, color: Colors.red, size: 14),
                    const SizedBox(height: 3),
                    isAvailable
                        ? const Text(
                            '가능',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff767676),
                            ),
                          )
                        : const Text(
                            '불가능',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff767676),
                            ),
                          ),
                  ],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DictContentsScreen(
                          title: title, contents: contents)));
            },
          ),
        ),
      ),
      const SizedBox(height: 10)
    ],
  );
}
