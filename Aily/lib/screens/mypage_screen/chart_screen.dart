import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:aily/utils/indicator.dart';
import '../../class/urls.dart';
import 'dart:math';

class UserChartScreen extends StatefulWidget {
  const UserChartScreen({Key? key}) : super(key: key);

  @override
  ChartScreenState createState() => ChartScreenState();
}

class ChartScreenState extends State<UserChartScreen> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> responseData = [];
  bool isLoading = true;
  int total = 0;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        URL().historypaxURL,
        data: {"nickname": "신윤찬"},
      );
      if (response.statusCode == 200) {
        List<dynamic> responseBody = response.data;
        responseData = List<Map<String, dynamic>>.from(response.data);
        data = responseBody.cast<Map<String, dynamic>>();
        total = calculateTotal();
      } else {
        // 오류 처리
      }
    } catch (e) {
      // 예외 처리
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Color genColor = Colors.green;
    Color canColor = Colors.blue;
    Color petColor = Colors.yellow;

    double genPercent = (calculatePercentage("gen") / total) * 100;
    double canPercent = (calculatePercentage("can") / total) * 100;
    double petPercent = (calculatePercentage("pet") / total) * 100;

    PieChartData genPieChartData = PieChartData(genColor, genPercent);
    PieChartData canPieChartData = PieChartData(canColor, canPercent);
    PieChartData petPieChartData = PieChartData(petColor, petPercent);

    List<PieChartData> pieChartDataList = [genPieChartData, canPieChartData, petPieChartData];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          '통계',
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
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
      body: Center(
        child:
        data.isEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.82,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Text('잠시만 기다려주세요..', style: TextStyle(fontSize: 16))
              ],
            ),
          ),
        )
            : Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: PieChart(
                    data: pieChartDataList,
                    radius: 60,
                    rotate: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '총 버린 개수',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '$total',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 38,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Indicator(
                      color: genColor,
                      text: '일반(${genPercent.toStringAsFixed(1)}%)',
                      isSquare: false,
                      textColor: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Indicator(
                      color: canColor,
                      text: '캔(${canPercent.toStringAsFixed(1)}%)',
                      isSquare: false,
                      textColor: Colors.black,
                    ),
                    const SizedBox(width: 10),
                    Indicator(
                      color: petColor,
                      text: '페트(${petPercent.toStringAsFixed(1)}%)',
                      isSquare: false,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  double calculatePercentage(String category) {
    double categoryTotal = 0;
    for (var item in data) {
      categoryTotal += item[category].toDouble();
    }
    return categoryTotal;
  }

  int calculateTotal() {
    double total = 0;
    for (var item in data) {
      total += item["can"].toDouble() + item["gen"].toDouble() + item["pet"].toDouble();
    }
    return total.truncate();
  }
}

class PieChartData {
  const PieChartData(this.color, this.percent);

  final Color color;
  final double percent;
}

class PieChart extends StatelessWidget {
  PieChart({
    required this.data,
    required this.radius,
    this.strokeWidth = 8,
    this.rotate = 0.0,
    this.child,
    Key? key,
  })  :
        assert(data.fold<double>(0, (sum, data) => sum + data.percent) <= 100),
        super(key: key);

  final List<PieChartData> data;
  final double radius;
  final double strokeWidth;
  final double rotate;
  final Widget? child;

  @override
  Widget build(context) {
    return CustomPaint(
      painter: _Painter(strokeWidth, data, rotate),
      size: Size.square(radius),
      child: SizedBox.square(
        dimension: radius * 2,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class _PainterData {
  const _PainterData(this.paint, this.radians);

  final Paint paint;
  final double radians;
}

class _Painter extends CustomPainter {
  _Painter(double strokeWidth, List<PieChartData> data, double rotate) {
    dataList = data.map((e) => _PainterData(
      Paint()
        ..color = e.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
      // remove padding from stroke
      (e.percent - _padding) * _percentInRadians,
    )).toList();

    _startAngle = -1.570796 + _paddingInRadians / 2 + (rotate * _percentInRadians);
  }

  static const _percentInRadians = 0.062831853071796;
  static const _padding = 4;
  static const _paddingInRadians = _percentInRadians * _padding;

  static double _startAngle = -1.570796 + _paddingInRadians / 2;

  late final List<_PainterData> dataList;


  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    double startAngle = _startAngle;

    for (final data in dataList) {
      final path = Path()..addArc(rect, startAngle, data.radians);

      startAngle += data.radians + _paddingInRadians;

      canvas.drawPath(path, data.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}


class BarChart extends CustomPainter {
  final Color color;
  final List<double> data;
  final List<String> labels;
  final String title;
  double bottomPadding = 0.0;
  double leftPadding = 0.0;
  double textScaleFactorXAxis = 0.5; //X 폰트사이즈
  double textScaleFactorYAxis = 0.3; //Y 폰트사이즈

  BarChart({
    required this.data,
    required this.labels,
    required this.title,
    this.color = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 텍스트 공간을 미리 정한다.
    setTextPadding(size);

    List<Offset> coordinates = getCoordinates(size);

    drawBar(canvas, size, coordinates);
    drawXLabels(canvas, size, coordinates);
    drawYLabels(canvas, size, coordinates);
    //drawYLines(canvas, size, coordinates);
    drawLines(canvas, size, coordinates);
    drawTitle(canvas, size, coordinates);
  }

  @override
  bool shouldRepaint(BarChart oldDelegate) {
    return oldDelegate.data != data;
  }

  void setTextPadding(Size size) {
    // 세로 크기의 1/10만큼 텍스트 패딩
    bottomPadding = size.height / 10;
    // 가로 길이 1/10만큼 텍스트 패딩
    leftPadding = size.width / 10;
  }

  void drawBar(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    // 막대 그래프 넓이
    double barWidthMargin = size.width * 0.1;
    double barOffset = 10.0;

    for (int index = 0; index < coordinates.length; index++) {
      Offset offset = coordinates[index];
      double left = offset.dx + barOffset;
      // 간격만큼 가로로 이동
      double right = offset.dx + barOffset + barWidthMargin;

      double top = offset.dy;
      // 텍스트 크기만큼 패딩을 빼준다. 그래서 텍스트와 겹치지 않게 한다.
      double bottom = size.height - bottomPadding;

      Rect rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, paint);

      // 데이터 값을 그래프 위에 표시
      String dataValue = data[index].toStringAsFixed(2);
      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.blueAccent.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        text: dataValue,
      );
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();

      double textX = left + (barWidthMargin / 2) - (tp.width / 2);
      double textY = top - tp.height - 4; // 4는 데이터 값과 막대 사이의 여백

      tp.paint(canvas, Offset(textX, textY));
    }
  }


  // x축 텍스트(레이블)를 그린다.
  void drawXLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    // 화면 크기에 따라 유동적으로 폰트 크기를 계산한다.

    for (int index = 0; index < labels.length; index++) {
      TextSpan span = TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20, //fontSize
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        text: labels[index],
      );

      TextPainter tp =
      TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();

      Offset offset = coordinates[index];
      double dx = offset.dx + 10;
      double dy = size.height - tp.height;

      tp.paint(canvas, Offset(dx, dy));
    }
  }

  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    drawYText(canvas, "0", 18, size.height - 50);
    drawYText(canvas, "100", 18, size.height - 320);
  }

  double calculateFontSize(String value, Size size, {required bool xAxis}) {
    int numberOfCharacters = value.length;
    double fontSize = (size.width / numberOfCharacters) / data.length;

    if (xAxis) {
      fontSize *= textScaleFactorXAxis;
    } else {
      fontSize *= textScaleFactorYAxis;
    }
    return fontSize;
  }

  // x축 & y축 구분하는 선을 그린다.
  void drawLines(Canvas canvas, Size size, List<Offset> coordinates) {
    Paint paint = Paint()
      ..color = Colors.blueGrey.shade100
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    double bottom = size.height - bottomPadding;
    double left = coordinates[0].dx;

    Path path = Path();
    path.moveTo(left, 0);
    path.lineTo(left, bottom);
    path.lineTo(size.width, bottom);

    canvas.drawPath(path, paint);
  }

  void drawTitle(Canvas canvas, Size size, List<Offset> coordinates) {
    TextSpan span = TextSpan(
      style: const TextStyle(
        fontSize: 23,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      text: title,
    );
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();

    double dx = 0;
    double dy = tp.height * -2;//coordinates[indexOfMax].dy - tp.height - 50;

    tp.paint(canvas, Offset(dx, dy));
  }


  void drawYText(Canvas canvas, String text, double fontSize, double y) {
    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
      ),
      text: text,
    );
    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);

    tp.layout();

    Offset offset = Offset(0.0, y);
    tp.paint(canvas, offset);
  }

  List<Offset> getCoordinates(Size size) {
    List<Offset> coordinates = <Offset>[];
    double maxData = 100.0;

    double width = size.width - leftPadding;
    double minBarWidth = width / data.length;

    for (int index = 0; index < data.length; index++) {
      double left = minBarWidth * (index) + leftPadding;
      double normalized = data[index] / maxData;
      double height = size.height - bottomPadding;
      double top = height - normalized * height;

      Offset offset = Offset(left, top);
      coordinates.add(offset);
    }
    return coordinates;
  }
}