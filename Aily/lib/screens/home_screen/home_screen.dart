import 'dart:convert';
import 'dart:async';
import 'package:aily/screens/home_screen/push_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../class/user_data.dart';
import '../../class/urls.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late double screenWidth = 0.0;
  late double screenHeight = 0.0;
  late String? username;
  late int? userpoint;
  Color myColor = const Color(0xFFF8B195);
  var user = UserData();
  Dio dio = Dio();
  Timer? timer;

  String? filterStr = "전체";
  List<Map<String, dynamic>> filteredData = [];
  late List<Map<String, dynamic>> processedData = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getUser();
    timer = Timer.periodic(const Duration(milliseconds: 100),
        (timer) => accrualdetails(user.phonenumber.toString()));
  }

  @override
  void dispose() {
    super.dispose();
    dio.close();
    timer?.cancel();
  }

  void _getUser() {
    setState(() {
      username = user.nickname;
    });
  }

  //이용내역
  void accrualdetails(String phoneNumber) async {
    try {
      Response response = await dio.post(
        URL().staticsURL,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'phonenumber': "0$phoneNumber",
        },
      );
      if (response.statusCode == 200) {
        timer?.cancel();
        Map<String, dynamic> data = json.decode(response.data);
        List<dynamic> phoneNumberList = data["0$phoneNumber"];

        setState(() {
          processedData = phoneNumberList.map((item) {
            return {
              "phonenumber": item["phonenumber"],
              "GEN": item["GEN"],
              "CAN": item["CAN"],
              "PET": item["PET"],
              "POINT": item["POINT"],
              "TIMESTAMP": item["TIMESTAMP"],
            };
          }).toList();
          _refreshData();
        });
      }
    } catch (error) {
      //
    }
  }

  void _pushScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PushScreen()));
  }

  void _refreshData() {
    filteredData = [];

    if (filterStr == null || filterStr == '전체') {
      filteredData = processedData;
    } else {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime.now();

      if (filterStr == '1개월') {
        startDate = now.subtract(const Duration(days: 30));
      } else if (filterStr == '3개월') {
        startDate = now.subtract(const Duration(days: 90));
      } else if (filterStr == '6개월') {
        startDate = now.subtract(const Duration(days: 180));
      } else if (filterStr == '12개월') {
        startDate = now.subtract(const Duration(days: 365));
      }

      for (var item in processedData) {
        DateTime dateTime = DateTime.parse(item['TIMESTAMP']);
        if (dateTime.isAfter(startDate)) {
          filteredData.add(item);
        }
      }
    }
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      initialValue: filterStr,
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          buildPopupMenuItem('전체'),
          buildPopupMenuItem('1개월'),
          buildPopupMenuItem('3개월'),
          buildPopupMenuItem('6개월'),
          buildPopupMenuItem('12개월'),
        ];
      },
      onSelected: (String value) {
        setState(() {
          filterStr = value;
          _refreshData();
        });
      },
      child: const Icon(Icons.keyboard_arrow_down_outlined,
          size: 24, color: Colors.grey),
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        value.isEmpty ? '전체' : value,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final EdgeInsetsGeometry margin = isAndroid
        ? const EdgeInsets.only(left: 24, top: 14) // 안드로이드일 경우
        : const EdgeInsets.only(left: 24); // 아이폰일 경우

    final EdgeInsetsGeometry noticeMargin = isAndroid
        ? const EdgeInsets.only(right: 32, top: 24) // 알림 아이콘 안드로이드일 경우
        : const EdgeInsets.only(right: 32); // 아이폰일 경우
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Container(
          margin: margin,
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 40, // 이미지 크기
            height: 40,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: noticeMargin,
                onPressed: () {
                  // 클릭 시 실행될 코드
                  _pushScreen();
                },
                icon: SvgPicture.asset(
                  'assets/images/icons/notification_line_icon.svg',
                  width: 24, // 이미지 크기
                  height: 24,
                ),
              ),
              Positioned(
                  top: 18,
                  left: 12,
                  child: GestureDetector(
                    onTap: () {
                      _pushScreen();
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
      body: homeWidget(
        username!,
        context,
      ),
    );
  }

  Widget homeWidget(String username, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth * 0.88, // 포인트 컨테이너 길이
              height: screenHeight * 0.15, // 높이
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/icons/wallet.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Expanded(
                          child: Text(
                            '님의 포인트',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              accrualdetails(user.phonenumber.toString());
                            },
                            child: const Icon(Icons.refresh, size: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.023),
                  processedData.isNotEmpty
                      ? Text(
                          '${NumberFormat('#,###').format(processedData.last["POINT"])}원',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 1.5),
                        ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: screenWidth * 0.88,
          height: screenHeight * 0.57,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('이용내역',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.45),
                    Text(filterStr!),
                    buildPopupMenuButton(),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                          accrualdetails(user.phonenumber.toString());
                        },
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: Colors.white,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredData.length,
                              reverse: true,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                final item = filteredData[index];
                                int gen = item["GEN"];
                                int can = item["CAN"];
                                int pet = item["PET"];
                                int cntValue = (gen + can + pet) * 100;

                                if (item["POINT"] == 0) {
                                  return Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.16),
                                      const Text(
                                        "이용하신 내역이 없습니다.",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  DateTime dateTime =
                                      DateTime.parse(item['TIMESTAMP']);
                                  String formattedDate =
                                      '${dateTime.year}-${dateTime.month}-${dateTime.day}';

                                  if (index == processedData.length - 1 ||
                                      formattedDate !=
                                          '${DateTime.parse(processedData[index + 1]['TIMESTAMP']).year}-${DateTime.parse(processedData[index + 1]['TIMESTAMP']).month}-${DateTime.parse(processedData[index + 1]['TIMESTAMP']).day}') {
                                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                                    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                                    // });
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            formattedDate,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        listTile(
                                          context,
                                          '일반: ${item["GEN"]}, 캔: ${item["CAN"]}, 페트: ${item["PET"]}',
                                          item['TIMESTAMP'],
                                          cntValue,
                                          item["POINT"],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return listTile(
                                      context,
                                      '일반: ${item["GEN"]}, 캔: ${item["CAN"]}, 페트: ${item["PET"]}',
                                      item['TIMESTAMP'],
                                      cntValue,
                                      item["POINT"],
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget listTile(
    BuildContext context, String title, String date, int incPoint, totPoint) {
  Color myColor = const Color(0xFFF8B195);
  var user = UserData();

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
            contentPadding: const EdgeInsets.symmetric(horizontal: 25),
            title: Text(title, style: const TextStyle(fontSize: 16)),
            subtitle: Text(date),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('+${user.formatInt(incPoint)}',
                        style:
                            const TextStyle(fontSize: 17, color: Colors.red)),
                    Text('${user.formatInt(totPoint)}원',
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
