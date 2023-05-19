import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class dictionaryScreen extends StatefulWidget {
  const dictionaryScreen({Key? key}) : super(key: key);

  @override
  _dictionaryScreenState createState() => _dictionaryScreenState();
}

class _dictionaryScreenState extends State<dictionaryScreen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  String searchStr = '';
  bool status = false;
  final FocusNode _searchFocusNode = FocusNode();

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
          body: DictionaryWidget(context)
        ),
      ),
    );
  }

  Widget DictionaryWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 72, left: 24, right: 24, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      '재활용 사전',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Center(
                    child: Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                                contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                hintText: "물품 검색",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: myColor),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      searchStr = searchctrl.text;
                                      _searchFocusNode.unfocus();
                                    });
                                  },
                                  child: SvgPicture.asset('assets/images/icons/search.svg')
                                )
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 48, // 적립내역 탭의 길이
                            height: MediaQuery.of(context).size.height * 0.61, // 높이
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('검색한 물품의 재활용 여부가 나타나요.',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                                const SizedBox(height: 30),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildListTiles(),
                                        _buildListTiles(),
                                        _buildListTiles(),
                                        _buildListTiles(),
                                        _buildListTiles(),
                                        _buildListTiles(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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
    if (searchStr.isNotEmpty){
      listTiles.add(_ListTile(context, searchStr, status));
    }
    return Column(children: listTiles);
  }
}

Widget _ListTile(BuildContext context, String title, bool isAvailable) {
  Color myColor = const Color(0xFFF8B195);

  return Column(
    children: [
      Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: myColor.withOpacity(0.3)
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Theme(
          data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            leading: Icon(Icons.restore_from_trash, color: myColor),
            title: Text(title, style: TextStyle(fontSize: 18, color: myColor)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "카테고리",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff989898),
                      ),
                    ),
                    Text('페트\n'),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '상태',
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ));
            },
          ),
        ),
      ),
      const SizedBox(height: 10)
    ],
  );
}