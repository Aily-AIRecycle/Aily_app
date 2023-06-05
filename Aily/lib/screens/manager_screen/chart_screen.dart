import 'package:flutter/material.dart';
import 'dart:math';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  ChartScreenState createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> {
  Color myColor = const Color(0xFFF8B195);
  Color backColor = const Color(0xFFF6F1F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: SingleChildScrollView(
        child: chartWidget(context),
      ),
    );
  }

  Widget chartWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 72, left: 24, right: 24, bottom: 24),
          child: Column(
            children: [

              Container(
                height: 0.5,
                width: MediaQuery.of(context).size.width * 0.85,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              const Text('월별', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              //SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.85, MediaQuery.of(context).size.height * 0.4),
                foregroundPainter: BarChart(
                  data: <double>[105, 55, 99, 150, 300, 500, 120, 1000, 1300, 1800],
                  labels: <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10'
                  ],
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BarChart extends CustomPainter {
  final Color color;
  final List<double> data;
  final List<String> labels;
  double bottomPadding = 0.0;
  double leftPadding = 0.0;
  double textScaleFactorXAxis = 0.5; //X 폰트사이즈
  double textScaleFactorYAxis = 1.2; //Y 폰트사이즈

  BarChart({required this.data, required this.labels, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    // 텍스트 공간을 미리 정한다.
    setTextPadding(size);

    List<Offset> coordinates = getCoordinates(size);

    drawBar(canvas, size, coordinates);
    drawXLabels(canvas, size, coordinates);
    drawYLabels(canvas, size, coordinates);
    drawLines(canvas, size, coordinates);
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
    double barWidthMargin = size.width * 0.05;
    double barOffset = 7.0;

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
      String dataValue = '${data[index].toInt()}';
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
    double fontSize = calculateFontSize(labels[0], size, xAxis: true);

    for (int index = 0; index < labels.length; index++) {
      TextSpan span = TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        text: labels[index],
      );
      TextPainter tp =
      TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();

      Offset offset = coordinates[index];
      double dx = offset.dx;
      double dy = size.height - tp.height;

      tp.paint(canvas, Offset(dx, dy));
    }
  }

  // Y축 텍스트(레이블)를 그린다. 최저값과 최고값을 Y축에 표시한다.
  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double bottomY = coordinates[0].dy;
    double topY = coordinates[0].dy;
    int indexOfMin = 0;
    int indexOfMax = 0;

    for (int index = 0; index < coordinates.length; index++) {
      double dy = coordinates[index].dy;
      if (bottomY < dy) {
        bottomY = dy;
        indexOfMin = index;
      }
      if (topY > dy) {
        topY = dy;
        indexOfMax = index;
      }
    }
    String minValue = '${data[indexOfMin].toInt()}';
    String maxValue = '${data[indexOfMax].toInt()}';

    double fontSize = calculateFontSize(maxValue, size, xAxis: false);

    drawYText(canvas, minValue, fontSize, bottomY);
    drawYText(canvas, maxValue, fontSize, topY);
  }

  // 화면 크기에 비례해 폰트 크기를 계산한다.
  double calculateFontSize(String value, Size size, {required bool xAxis}) {
    // 글자수에 따라 폰트 크기를 계산하기 위함
    int numberOfCharacters = value.length;
    // width가 600일 때 100글자를 적어야 한다면, fontSize는 글자 하나당 6이어야 한다.
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

    double maxData = data.reduce(max);

    double width = size.width - leftPadding;
    double minBarWidth = width / data.length;

    for (int index = 0; index < data.length; index++) {
      // 그래프의 가로 위치를 정한다.
      double left = minBarWidth * (index) + leftPadding;
      // 그래프의 높이가 [0~1] 사이가 되도록 정규화 한다.
      double normalized = data[index] / maxData;
      // x축에 표시되는 글자들과 겹치지 않게 높이에서 패딩을 제외한다.
      double height = size.height - bottomPadding;
      // 정규화된 값을 통해 높이를 구한다.
      double top = height - normalized * height;

      Offset offset = Offset(left, top);
      coordinates.add(offset);
    }

    return coordinates;
  }
}