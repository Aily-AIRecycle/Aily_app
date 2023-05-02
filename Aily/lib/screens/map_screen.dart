import 'dart:async';
import 'package:Aily/utils/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../class/location.dart';
import '../class/LocationData.dart';
import '../class/URLs.dart';
import '../class/garbageData.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen>{
  @override
  bool get wantKeepAlive => true;

  Set<Marker> markers = {};
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  late String searchStr = '';
  final FocusNode _focusNode = FocusNode();
  late Set<JavascriptChannel>? channel = null;
  late WebViewController? controller = null;
  late String label, distance = '';
  List<List<String>> resultList = [];
  Location location = Location();
  bool updatebool = false;
  bool status = false;
  Timer? timer, timer2;

  @override
  void initState() {
    super.initState();
    searchctrl = TextEditingController();
    location.getLocationPermission();
    _getLocation();
    _getDistance();
    timer2 = Timer.periodic(const Duration(milliseconds: 15), (timer) => _getLocation());
    timer = Timer.periodic(const Duration(seconds: 1), (timer) => _getDistance());
  }

  void _getLocation() async {
    await location.getCurrentLocation();
  }

  @override
  void dispose(){
    searchctrl.dispose();
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  String _getSearchString(String inputStr, List<GarbageData> garbageData) {
    String searchStr = '';
    if (inputStr.contains('Aily1') || inputStr.contains('동양')) {
      searchStr = '동양미래대점';
      status = garbageData[0].status;
    } else if (inputStr.contains('Aily2') || inputStr.contains('3호')) {
      searchStr = '3호관';
      status = garbageData[1].status;
    } else if (inputStr.isEmpty) {
      searchStr = '';
    }
    return searchStr;
  }

  Future<void> _updateDistanceText() async {
    final String str = searchctrl.text.trim();
    List<GarbageData> garbageData = await fetchGarbage();
    final String searchStr = _getSearchString(str, garbageData);
    distance = LocationData().data[searchStr]!;
    setState(() {});
  }

  void _search() {
    final String str = searchctrl.text.trim();
    if (str.contains('Aily1') || str.contains('동양')){
      searchStr = '동양미래대점';
      distance = LocationData().data[searchStr]!;
    } else if (str.contains('Aily2') || str.contains('3호')){
      searchStr = '3호관';
      distance = LocationData().data[searchStr]!;
    }else if (str.isEmpty){
      showMsg(context, '검색', '검색어를 입력해주세요.');
      searchStr = '';
    }
    else {
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
    // await location.getCurrentLocation();
    await controller!.runJavascript("getDistance(${location.latitude}, ${location.longitude})");
    if (updatebool && !_focusNode.hasFocus){
      _updateDistanceText();
    }else{
      updatebool = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    channel = {
      JavascriptChannel(
          name: 'onClickMarker',
          onMessageReceived: (message) {
            final String msg = message.message;
            List<String> messages = msg.split('\n');
            messages.forEach((message) {
              List<String> parts = message.split(':');
              String label = parts[0];
              String distance = parts[1];
              if (label != null && distance != null) {
                LocationData().data[label] = distance;
              }
            });
          })
    };
    return Scaffold(
      backgroundColor: Colors.white,
      body: MapWidget(context),
    );
  }

  Widget _buildListTiles() {
    List<Widget> listTiles = [];
    if (searchStr.isNotEmpty){
      listTiles.add(_ListTile(context, searchStr, int.parse(distance), status));
    }
    return Column(children: listTiles);
  }

  Widget MapWidget(BuildContext context) {
    double ratio = MediaQuery.of(context).devicePixelRatio * 0.4;
    return Column(
      children: <Widget>[
        Expanded(
          child: ClipRect(
            child: Transform.scale(
              scale: ratio,
              child: WebView(
                initialUrl: URL().mapURL,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  this.controller = controller;
                },
                javascriptChannels: channel,
              ),
            ),
          )
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
                        width: 350,
                        child: TextField (
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value){
                            _search();
                          },
                          style: TextStyle(color: Colors.grey.shade600),
                          focusNode: _focusNode,
                          controller: searchctrl,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              onPressed: (){
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
          )
        ),
      ],
    );
  }
}

Widget _ListTile(BuildContext context, String title, int distance, bool isAvailable) {
  Color myColor = const Color(0xFFF8B195);

  return Card(
    shape: RoundedRectangleBorder(
      side: BorderSide(
          color: myColor.withOpacity(0.3)
      ),
      borderRadius: BorderRadius.circular(15.0),
    ),
    elevation: 0,
    margin: const EdgeInsets.symmetric(horizontal: 35),
    child: ListTile(
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      leading: Icon(Icons.directions_walk, color: myColor),
      title: Text(title, style: TextStyle(fontSize: 18, color: myColor)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("남은거리", style: TextStyle(fontSize: 12)),
              Text('${distance}M\n'),
            ],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('상태', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 5),
              isAvailable ? const Icon(Icons.circle, color: Colors.lightGreenAccent, size: 14) :
              const Icon(Icons.circle, color: Colors.red, size: 14),
              const SizedBox(height: 3),
              isAvailable ? const Text('사용 가능', style: TextStyle(fontSize: 12)) : const Text('사용 불가', style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
      onTap: () {
        showMsg(context, '까꿍', title);
      },
    ),
  );
}




