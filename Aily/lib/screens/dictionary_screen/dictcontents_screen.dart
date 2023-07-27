import 'package:flutter/material.dart';


class DictContentsScreen extends StatefulWidget {
  final String title;
  final String contents;

  const DictContentsScreen({Key? key, required this.title, required this.contents}) : super(key: key);

  @override
  DictContentsScreenState createState() => DictContentsScreenState();
}

class DictContentsScreenState extends State<DictContentsScreen> {
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
      body: dictionaryWidget(context),
    );
  }

  Widget dictionaryWidget(BuildContext context) {
    String contents = widget.contents.replaceAll('· ', '\n\n· ');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 50, left: 24, right: 24, bottom: 24),
          child: Column(
            children: [
              const Row(
                children: [
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
                child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.88,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.7,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                contents,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16), //16
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
        ),
      ],
    );
  }
}