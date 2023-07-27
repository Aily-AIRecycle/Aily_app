import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  FAQScreenState createState() => FAQScreenState();
}

class FAQScreenState extends State<FAQScreen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  String searchStr = '';
  final FocusNode _searchFocusNode = FocusNode();

  final List<Map<String, String>> faqList = [
    {
      'title': '어떤 종류의 자원을 수집하면 되나요?',
      'content':
      'Aily는 지역마다 회수하는 자원이 상이하나, 대부분의\n지역에서는 현재 캔, 페트를 수집하고 있습니다.'
    },
    {
      'title': 'Aily 회원가입은 어떻게 하나요?',
      'content': 'Aily 회원가입은 Aily 홈페이지 또는 모바일 앱을 통해 가능합니다.'
    },
    {'title': 'Aily 포인트는 어떻게 적립하나요?', 'content': 'Aily 기기를 이용하여 분리수거를 통해 포인트가 적립됩니다. (개당 100원)'},
    {'title': 'Aily 이용내역은 어디서 확인하나요?', 'content': '홈 화면에 이용내역 검색필터 기능을 통해 확인하실 수 있습니다.'},
    {'title': 'Aily의 뜻이 뭔가요?', 'content': 'AI Recycle의 이름을 조금 변형시켰습니다.'},
    {'title': 'Aily의 포인트를 타인에게 양도 할 수 있나요?', 'content': '현재 포인트를 타인에게 양도 할 수 없습니다. 추후에 업데이트 예정입니다.'},
  ];

  @override
  void initState() {
    super.initState();
    searchctrl = TextEditingController();
  }

  @override
  void dispose() {
    searchctrl.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredList = faqList
        .where((faq) =>
        faq['title']!.toLowerCase().contains(searchStr.toLowerCase()))
        .toList();

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
            centerTitle: true,
            backgroundColor: Colors.white,
            title: const Text(
                '자주하는 질문', style: TextStyle(fontSize: 17, color: Colors.black)),
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
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
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
                            horizontal: 20, vertical: 10),
                        hintText: '질문을 검색해보세요.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: myColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          color: Colors.grey.shade400,
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              searchStr = searchctrl.text;
                              _searchFocusNode.unfocus();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  filteredList.isEmpty ? const Column(
                    children: [
                      SizedBox(height: 50),
                      Text('검색 결과가 없습니다.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text('검색어가 정확한지 확인해주세요.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200))
                    ],
                  ) :
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final faq = filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            listTile(context, _searchFocusNode, faq['title']!, faq['content']!)
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget listTile(BuildContext context, FocusNode focus, String title, String content) {
  return Column(
    children: [
      Theme(
        data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent
        ),
        child: ExpansionTile(
          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              focus.unfocus();
            }
          },
          textColor: Colors.black,
          iconColor: Colors.grey.shade600,
          title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade100,
              child: Text(content, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
      Container(
        height: 0.5,
        width: MediaQuery.of(context).size.width * 0.87,
        color: Colors.grey.shade400,
      ),
    ],
  );
}