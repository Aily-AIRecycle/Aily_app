import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'AccountPage.dart';
import 'NoticePage.dart';
import 'FAQPage.dart';

class GarbageCanPage extends StatefulWidget {
  const GarbageCanPage({super.key});

  @override
  _GarbageCanPageState createState() => _GarbageCanPageState();
}

class _GarbageCanPageState extends State<GarbageCanPage> {
  late String phoneNumber;
  int _normalAmount = 0;
  int _plasticAmount = 0;
  int _glassAmount = 0;

  Future<void> fetchTrashLevel() async {
    final response = await http.get(Uri.parse('https://tinyurl.com/srlafhks'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _normalAmount = data['normal'] ?? 0;
        _plasticAmount = data['plastic'] ?? 0;
        _glassAmount = data['glass'] ?? 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 일정 주기마다 쓰레기통 데이터를 서버로부터 가져옴
    Timer.periodic(const Duration(seconds: 3), (timer) => fetchTrashLevel());
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    phoneNumber = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('분리수거'),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Username'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('U'),
              ),
            ),
            ListTile(
              title: const Text('계정정보'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage(phoneNumber: phoneNumber)),
                );
              },
            ),
            ListTile(
              title: const Text('공지사항'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NoticePage()),
                );
              },
            ),
            ListTile(
              title: const Text('FAQ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGarbageCan("일반", _normalAmount),
                _buildGarbageCan("플라", _plasticAmount),
                _buildGarbageCan("유리", _glassAmount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildGarbageCan(String title, int amount) {
  final imageAsset = title == '일반'
      ? 'assets/images/normal.png'
      : title == '플라'
      ? 'assets/images/plastic.png'
      : 'assets/images/glass.png';

  final percent = amount / 100;

  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 160,
            width: 80,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
              child: CustomPaint(
                painter: _GarbageCanPainter(percent),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, 14),
            child: Text(
              '${(percent * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

class _GarbageCanPainter extends CustomPainter {
  final double percent;
  final Paint _paint;
  late Offset _center;
  late double _radius;
  late double _innerRadius;

  _GarbageCanPainter(this.percent)
      : _paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 5,
        _center = const Offset(0, 0),
        _radius = 0,
        _innerRadius = 0;

  @override
  void paint(Canvas canvas, Size size) {
    _center = Offset(size.width / 2, size.height / 1.7);
    _radius = size.width / 2.7;
    _innerRadius = _radius - 30;

    if (percent <= 0.1) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.blueGrey[900]!);
    } else if (percent <= 0.2) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.yellow[900]!);
    } else if (percent <= 0.3) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.orange[900]!);
    } else if (percent <= 0.4) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.deepOrange[900]!);
    } else if (percent <= 0.5) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.red[900]!);
    } else if (percent <= 0.6) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.red[900]!);
      _drawInnerArc(canvas, Colors.deepOrange[900]!);
    } else if (percent <= 0.7) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.red[900]!);
      _drawInnerArc(canvas, Colors.orange[900]!);
    } else if (percent <= 0.8) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.red[900]!);
      _drawInnerArc(canvas, Colors.yellow[900]!);
    } else if (percent <= 0.9) {
      _drawCircle(canvas, Colors.white70);
      _drawArc(canvas, Colors.red[900]!);
      _drawInnerArc(canvas, Colors.blueGrey[900]!);
    } else {
      _drawCircle(canvas, Colors.red);
    }
  }

  void _drawCircle(Canvas canvas, Color color) {
    _paint.color = color;
    canvas.drawCircle(_center, _radius, _paint);
  }

  void _drawArc(Canvas canvas, Color color) {
    _paint.color = color;
    canvas.drawArc(
        Rect.fromCircle(center: _center, radius: _radius),
        pi * 1.5,
        percent * pi * 2,
        false,
        _paint);
  }

  void _drawInnerArc(Canvas canvas, Color color) {
    _paint.color = color;
    canvas.drawArc(
        Rect.fromCircle(center: _center, radius: _innerRadius),
        pi * 1.5,
        percent * pi * 2,
        false,
        _paint);
  }

  @override
  bool shouldRepaint(_GarbageCanPainter oldDelegate) =>
      oldDelegate.percent != percent;
}