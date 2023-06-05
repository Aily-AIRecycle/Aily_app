import 'dart:async';
import 'package:aily/screens/map_screen/garbage_screen.dart';
import 'package:aily/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../class/urls.dart';
import '../../class/user_data.dart';
import '../../class/location.dart';
import '../../class/garbage_data_class.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  late String searchStr = '';
  final FocusNode _focusNode = FocusNode();
  late final WebViewController _controller;
  late String label, distance = '';
  List<List<String>> resultList = [];
  Location location = Location();
  GarbageMerch merch = GarbageMerch();
  UserData user = UserData();
  bool updatebool = false;
  bool status = false;
  late int gen = 0;
  late int can = 0;
  late int pet = 0;
  Timer? timer, timer2;
  late double latitude = 0.0;
  late double longitude = 0.0;
  late StreamSubscription<Position> positionStream;
  final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high
  );

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
              Location().data[label] = distance;
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => _getDistance());
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

  String _getSearchString(String inputStr, List<GarbageData> garbageData) {
    String searchStr = '';
    status = garbageData[0].status;
    gen = garbageData[0].gen;
    can = garbageData[0].can;
    pet = garbageData[0].pet;

    if (inputStr.contains('Aily1') || inputStr.contains('고척')) {
      searchStr = '고척스카이돔';
    } else if (inputStr.contains('Aily2') || inputStr.contains('3호')) {
      searchStr = '3호관';
    } else if (inputStr.isEmpty) {
      searchStr = '';
    }
    return searchStr;
  }

  Future<void> _updateDistanceText() async {
    final String str = searchctrl.text.trim();
    List<GarbageData> garbageData = await fetchGarbage(str);
    merch.merch = str;
    final String searchStr = _getSearchString(str, garbageData);
    distance = Location().data[searchStr]!;
    setState(() {});
  }

  void _search() {
    final String str = searchctrl.text.trim();
    if (str.contains('Aily1') || str.contains('동양')) {
      searchStr = '고척스카이돔';
      distance = Location().data[searchStr]!;
    } else if (str.contains('Aily2') || str.contains('3호')) {
      searchStr = '3호관';
      distance = Location().data[searchStr]!;
    } else if (str.isEmpty) {
      showMsg(context, '검색', '검색어를 입력해주세요.');
      searchStr = '';
    } else {
      showMsg(context, '검색', '찾을 수 없습니다.');
    }
    _removeFocus();
    updatebool = true;
    setState(() {});
  }

  void _removeFocus() {
    _focusNode.unfocus();
  }

  void _getDistance() async {
    //내 위치를 실시간으로 보냄
    if (latitude != 0.0){
      if (user.nickname != "관리자"){
        await _controller.runJavaScript("getDistance($latitude, $longitude, false)");
      }else{
        await _controller.runJavaScript("getDistance($latitude, $longitude, true)");
      }
      if (updatebool && !_focusNode.hasFocus) {
        _updateDistanceText();
      } else {
        updatebool = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: mapWidget(context),
    );
  }

  Widget _buildListTiles() {
    List<Widget> listTiles = [];
    if (searchStr.isNotEmpty) {
      listTiles.add(listTile(context, searchStr, int.parse(distance), status, gen, can, pet));
    }
    return Column(children: listTiles);
  }

  Widget mapWidget(BuildContext context) {
    double ratio = MediaQuery.of(context).devicePixelRatio * 0.4;
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Expanded(
              child: ClipRect(
                child: Transform.scale(
                  scale: ratio,
                  child: WebViewWidget(controller: _controller),
                ),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 48,
                            height: 50,
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                _search();
                              },
                              style: TextStyle(color: Colors.grey.shade600),
                              focusNode: _focusNode,
                              controller: searchctrl,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                hintText: '주소, 지역 검색',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: myColor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                suffixIcon: IconButton(
                                  color: Colors.grey.shade400,
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    _search();
                                  },
                                ),
                              ),
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Column(
                            children: [
                              const Text('현 위치에서 가까운 Aily의 위치가 나타나요.'),
                              const SizedBox(height: 20),
                              _buildListTiles(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

Widget listTile(BuildContext context, String title, int distance, bool isAvailable, int gen, can, pet) {
  Color myColor = const Color(0xFFF8B195);
  GarbageMerch merch = GarbageMerch();

  return Card(
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
        const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        leading: Icon(Icons.directions_walk, color: myColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: myColor,
            fontWeight: FontWeight.w600,
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
                isAvailable
                    ? const Icon(Icons.circle,
                    color: Colors.lightGreenAccent, size: 14)
                    : const Icon(Icons.circle, color: Colors.red, size: 14),
                const SizedBox(height: 3),
                isAvailable
                    ? const Text(
                  '사용 가능',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff767676),
                  ),
                )
                    : const Text(
                  '사용 불가',
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
          if (user.nickname == "관리자"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GarbageScreen(title: merch.merch!, gen: gen, can: can, pet: pet)));
          }
        },
      ),
    ),
  );
}
