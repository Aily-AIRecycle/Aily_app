import 'dart:async';
import 'package:aily/screens/map_screen/garbage_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';
import '../../class/garbage_data_class.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  final FocusNode _focusNode = FocusNode();
  late final WebViewController _controller;
  UserData user = UserData();

  List<dynamic> data = []; // 데이터를 저장할 리스트
  List<dynamic> filteredData = []; // 검색 결과를 저장할 리스트
  bool isSearching = false; // 검색 중인지 여부를 저장하는 변수
  List<String> distances = []; //마커 distance 리스트
  List<String> labels = []; //마커 label 리스트
  Map<String, dynamic> marker = {};


  Dio dio = Dio();
  Timer? timer, timer2;
  late double latitude = 0.0;
  late double longitude = 0.0;
  late StreamSubscription<Position> positionStream;
  final LocationSettings locationSettings =
      const LocationSettings(accuracy: LocationAccuracy.high);

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(URL().mapURL)) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'onClickMarker',
        onMessageReceived: (JavaScriptMessage message) {
          final String msg = message.message;
          List<String> messages = msg.split('\n');
          for (var message in messages) {
            List<String> parts = message.split(':');
            String label = parts[0];
            String distance = parts[1];
            if (label.isNotEmpty && distance.isNotEmpty) {
              marker[label] = distance;
            }
          }
        },
      )
      ..loadRequest(Uri.parse(URL().mapURL));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    searchctrl = TextEditingController();
    _getLocation();
    _getDistance();
    timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => _getDistance());
  }

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  void dispose() {
    searchctrl.dispose();
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  void fetchData() async {
    try {
      Response response = await Dio().get(
        URL().garbageURL,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      // 응답 데이터 리스트에 저장
      setState(() {
        data = response.data['garbage'];
        List<Map<String, dynamic>> updatedData = [];

        for (var item in data) {
          String merch = item['merch'];
          String distance = marker[merch];

          Map<String, dynamic> updatedItem = {
            'can': item['can'],
            'gen': item['gen'],
            'merch': merch,
            'pet': item['pet'],
            'distance': int.parse(distance),
            'status': item['status'],
          };
          updatedData.add(updatedItem);
        }
        data = updatedData;
      });
    } catch (error) {
      // error
    }
  }

  void filterData(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        filteredData = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      filteredData = data
          .where((item) => item['merch']
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
      isSearching = true;
    });
  }

  void _getDistance() async {
    //내 위치를 실시간으로 보냄
    if (latitude != 0.0) {
      if (user.nickname != "관리자") {
        await _controller
            .runJavaScript("getDistance($latitude, $longitude, false)");
      } else {
        await _controller
            .runJavaScript("getDistance($latitude, $longitude, true)");
      }
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: mapWidget(context),
        ),
      ),
    );
  }

  Widget mapWidget(BuildContext context) {
    double ratio = MediaQuery.of(context).devicePixelRatio * 0.4;
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ClipRect(
              child: Transform.scale(
                scale: ratio,
                child: WebViewWidget(controller: _controller),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              filterData(value);
            },
            style: TextStyle(color: Colors.grey.shade600),
            focusNode: _focusNode,
            controller: searchctrl,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              hintText: '주소, 지역 검색',
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
                    filterData(searchctrl.text);
                    _focusNode.unfocus();
                  });
                },
              ),
            ),
            obscureText: false,
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '현 위치에서 가까운 Aily의 위치가 나타나요.',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(height: 30),
                buildListTiles(distances),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListTiles(List<String> distances) {
    List<Widget> listTiles = [];

    final filteredList = isSearching ? filteredData : data;

    for (int i = 0; i < filteredList.length; i++) {
      //final String distance = distances[i];
      final item = filteredList[i];
      final String merch = item['merch'];
      final int gen = item['gen'];
      final int can = item['can'];
      final int pet = item['pet'];
      final int distance = item['distance'];
      final int status = item['status'];

      listTiles.add(
          listTile(context, merch, distance, status, gen, can, pet));
    }

    return Column(children: listTiles);
  }
}

Widget listTile(BuildContext context, String title, int distance,
    int isAvailable, int gen, can, pet) {
  Color myColor = const Color(0xFFF8B195);
  GarbageMerch merch = GarbageMerch();

  return Column(
    children: [
      Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: myColor.withOpacity(0.25)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.25,
        margin: const EdgeInsets.symmetric(horizontal: 35),
        child: Theme(
          data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent),
          child: ListTile(
            horizontalTitleGap: 0,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            leading: Icon(Icons.directions_walk, color: myColor),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: myColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "남은 거리",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff989898),
                      ),
                    ),
                    Text('${distance}M\n'),
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
                    isAvailable == 1
                        ? const Icon(Icons.circle, color: Colors.red, size: 14)
                        : isAvailable == 2
                            ? const Icon(Icons.circle,
                                color: Colors.yellow, size: 14)
                            : const Icon(Icons.circle,
                                color: Colors.lightGreenAccent, size: 14),
                    const SizedBox(height: 3),
                    isAvailable == 1
                        ? const Text(
                            '사용 불가',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff767676),
                            ),
                          )
                        : isAvailable == 2
                            ? const Text(
                                '사용 가능',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff767676),
                                ),
                              )
                            : const Text(
                                '사용 가능',
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
              UserData user = UserData();
              if (user.nickname == "관리자") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GarbageScreen(
                            title: merch.merch!,
                            gen: gen,
                            can: can,
                            pet: pet)));
              }
            },
          ),
        ),
      ),
      const SizedBox(height: 10)
    ],
  );
}
