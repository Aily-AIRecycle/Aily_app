import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';


class DictContentsScreen extends StatefulWidget {
  final String title;
  final String contents;
  final String image;

  const DictContentsScreen({Key? key, required this.title, required this.contents, required this.image}) : super(key: key);

  @override
  DictContentsScreenState createState() => DictContentsScreenState();
}

class DictContentsScreenState extends State<DictContentsScreen> {
  Color myColor = const Color(0xFFF8B195);

  @override
  void initState() {
    super.initState();
  }

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
        body: SingleChildScrollView(
          child: dictionaryWidget(context),
        )
    );
  }

  Widget dictionaryWidget(BuildContext context) {
    String contents = widget.contents.replaceAll('· ', '\n\n· ');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 30, left: 24, right: 24, bottom: 24),
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.33,
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    placeholder: (context, url) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.82,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          const Text('이미지를 불러올 수 없습니다.')
                        ],
                      );
                    },
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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