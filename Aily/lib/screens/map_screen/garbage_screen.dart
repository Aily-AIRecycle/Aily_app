import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class GarbageScreen extends StatefulWidget {
  final String title;
  final int gen;
  final int can;
  final int pet;

  const GarbageScreen({Key? key, required this.title, required this.gen, required this.can, required this.pet}) : super(key: key);

  @override
  GarbageScreenState createState() => GarbageScreenState();
}

class GarbageScreenState extends State<GarbageScreen> {
  int _genAmount = 0;
  int _petAmount = 0;
  int _canAmount = 0;
  double _genHeightPercent = 1.0,
      _canHeightPercent = 1.0,
      _petHeightPercent = 1.0;

  Color myColor = const Color(0xFFF8B195);

  Future<void> _getgarbage() async {
     _genAmount = widget.gen;
    _genHeightPercent = heightPercentage(widget.gen);
    _canAmount = widget.can;
    _canHeightPercent = heightPercentage(widget.can);
    _petAmount = widget.pet;
    _petHeightPercent = heightPercentage(widget.pet);
    setState(() {});
  }

  double heightPercentage(int n) {
    return 1.0 - ((n / 50.0) * 0.55);
  }

  @override
  void initState() {
    super.initState();
    _getgarbage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
            '포화도', style: TextStyle(fontSize: 18, color: Colors.black)),
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
      body: garbageWidget(context),
    );
  }

  Widget garbageWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Container(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    width: MediaQuery.of(context).size.width - 48,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xffF8B195).withOpacity(0.5),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffF8B195).withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: 40),
                const Text('현재 쓰레기 적재량이 나타나요',
                  style: TextStyle(
                    color: Color(0xff767676),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGarbageCan(context, '일반', _genAmount, _genHeightPercent),
                    _buildGarbageCan(context, '캔', _canAmount, _canHeightPercent),
                    _buildGarbageCan(context, '페트', _petAmount, _petHeightPercent),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildGarbageCan(BuildContext context, String label, int amount, double heightval) {
  final percent = amount / 100;
  Color gradientColor = const Color(0xfff67280);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Color(0xff353E5E),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  LiquidLinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xffF8B195),
                    borderWidth: 1.0,
                    borderRadius: 25.0,
                    direction: Axis.vertical,
                    valueColor: AlwaysStoppedAnimation<Color>(gradientColor),
                  ),
                  Positioned(
                    top: 65,
                    left: 0,
                    right: 0,
                    child: Text(
                      '${(percent * 100).toInt()}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}