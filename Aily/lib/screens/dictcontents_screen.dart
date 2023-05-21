import 'package:flutter/material.dart';


class dictContentsScreen extends StatefulWidget {
  final String title;
  final String contents;

  const dictContentsScreen({Key? key, required this.title, required this.contents}) : super(key: key);

  @override
  _dictContentsScreenState createState() => _dictContentsScreenState();
}

class _dictContentsScreenState extends State<dictContentsScreen> {
  Color myColor = const Color(0xFFF8B195);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
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
      body: DictionaryWidget(context),
    );
  }

  Widget DictionaryWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 50, left: 24, right: 24, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      '버리는 법',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 48,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.61,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.contents,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}