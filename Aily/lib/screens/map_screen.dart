import 'package:Aily/utils/ShowDialog.dart';
import 'package:label_marker/label_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../proves/mapTitleProvider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin<MapScreen> {
  @override
  bool get wantKeepAlive => true;

  Set<Marker> markers = {};
  GoogleMapController? controller;
  Color myColor = const Color(0xFFF8B195);
  late TextEditingController searchctrl;
  late String searchStr = '';
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchctrl = TextEditingController();
    initMap();
  }

  @override
  void dispose(){
    searchctrl.dispose();
    super.dispose();
  }

  void initMap() {
    final List<LatLng> locations = [
      const LatLng(37.500936916629, 126.86674390514),
      const LatLng(37.500923425185846, 126.86637168943172),
    ];
    for (int i = 0; i < locations.length; i++) {
      final title = "Aily_${i + 1}";
      final selectedLocation = locations[i];
      markers
          .addLabelMarker(LabelMarker(
        label: title,
        markerId: MarkerId(title),
        position: selectedLocation,
        backgroundColor: myColor,
        onTap: () {
          _onMarkerTapped(title);
        },
      ))
          .then(
            (value) {
          if (i == locations.length - 1) {
            controller?.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: locations[1],
                  northeast: locations[0],
                ),
                50.0, // padding
              ),
            );
          }
        },
      );
    }
  }

  void _onMarkerTapped(String title) {
    final TitleProvider titleProvider = Provider.of<TitleProvider>(context, listen: false);
    titleProvider.addTitle(title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('선택됨 : $title'),
      ),
    );
    setState(() {});
  }

  void _search() {
    final String str = searchctrl.text.trim();
    if (str.contains('Aily1') || str.contains('동양')){
      searchStr = '동양미래대학교';
    } else if (str.contains('Aily2')){
      searchStr = '코엑스';
    } else if (str.isEmpty){
      showMsg(context, '검색', '검색어를 입력해주세요.');
      searchStr = '';
    }
    else {
      showMsg(context, '검색', '찾을 수 없습니다.');
    }
    _removeFocus();
    setState(() {});
  }

  void _removeFocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color backColor = const Color(0xFFF6F1F6);

    return Scaffold(
      backgroundColor: backColor,
      body: MapWidget(context),
    );
  }

  Widget _buildListTiles() {
    List<Widget> listTiles = [];
    if (searchStr.isNotEmpty){
      listTiles.add(_ListTile(context, searchStr));
    }else{
      return const Text('현 위치에서 가까운 Aily의 위치가 나타나요.', style: TextStyle(fontSize: 16));
    }
    return Column(children: listTiles);
  }

  Widget MapWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.4,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.500936916629, 126.86674390514),
                    zoom: 18,
                  ),
                  markers: markers,
                  onMapCreated: ((mapController) {
                    setState(() {
                      controller = mapController;
                    });
                  }),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.983,
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
                      width: 370,
                      child: TextField(
                        focusNode: _focusNode,
                        controller: searchctrl,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          hintText: '주소, 지역 검색',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: myColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            color: Colors.black,
                            icon: const Icon(Icons.search),
                            onPressed: (){
                              _search();
                            },
                          ),
                        ),
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        _buildListTiles()
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _ListTile(BuildContext context, String title) {
  return ListTile(
    title: Text(title, style: const TextStyle(fontSize: 18)),
    subtitle: const Text('캔 사용가능 | 플라스틱 사용불가', style: TextStyle(fontSize: 16)),
    onTap: () {
      showMsg(context, '까꿍', title);
    },
  );
}
