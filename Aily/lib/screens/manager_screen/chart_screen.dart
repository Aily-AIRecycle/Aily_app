import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  ChartScreenState createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> {
  Color myColor = const Color(0xFFF8B195);
  Dio dio = Dio();
  List<Map<String, dynamic>> responseData = [];
  List<int> dropdownValues = [];
  int filterValue = 1;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      Response response = await Dio().get('https://aliy.store/member/member/showshowata');
      if (response.statusCode == 200) {
        responseData = List<Map<String, dynamic>>.from(response.data);

        dropdownValues = responseData.map((data) => int.parse(data['ailynumber'])).toList();
        setState(() {});
      }
    } catch (error) {
      //
    }
  }

  PopupMenuButton<int> buildPopupMenuButton(List<int> members) {
    return PopupMenuButton<int>(
      initialValue: filterValue,
      itemBuilder: (BuildContext context) {
        return members.map((int member) {
          return buildPopupMenuItem(member);
        }).toList();
      },
      onSelected: (int value) {
        setState(() {
          filterValue = value;
        });
      },
      child: const Icon(Icons.keyboard_arrow_down_outlined,
          size: 24, color: Colors.grey),
    );
  }

  PopupMenuItem<int> buildPopupMenuItem(int value) {
    return PopupMenuItem<int>(
      value: value,
      child: Text(
        "${value.toString()}번 기기",
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: chartWidget(context),
    );
  }

  Widget chartWidget(BuildContext context) {
    int index = dropdownValues.indexOf(filterValue);

    return Center(
      child: responseData.isEmpty || index >= responseData.length
          ? const CircularProgressIndicator(
        color: Colors.black,
        strokeWidth: 1.5,
      )
          : Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          // 데이터 통계
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${filterValue.toString()}번 기기", style: const TextStyle(fontSize: 23)),
              buildPopupMenuButton(dropdownValues),
            ],
          ),
          const SizedBox(height: 200),
          CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width * 0.85,
              MediaQuery.of(context).size.height * 0.4,
            ),
            foregroundPainter: BarChart(
              title: responseData[index]['day'],
              data: [
                double.parse(responseData[index]['avggen']),
                double.parse(responseData[index]['avgcan']),
                double.parse(responseData[index]['avgpet'])
              ],
              labels: ['일반', '캔', '페트'],
              color: Colors.deepOrange,
            ),
          )
        ],
      ),
    );
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
    double fontSize = calculateFontSize(labels[0], size, xAxis: true);

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

  // void drawYLines(Canvas canvas, Size size, List<Offset> coordinates) {
  //   double minValue = data.reduce(min);
  //   double maxValue = data.reduce(max);
  //
  //   for (int index = 0; index < coordinates.length; index++) {
  //     double dataValue = data[index];
  //     String dataValueText = '${dataValue.toInt()}';
  //
  //     double fontSize = 12;
  //     TextSpan span = TextSpan(
  //       style: TextStyle(
  //         fontSize: fontSize,
  //         color: Colors.black,
  //         fontFamily: 'Roboto',
  //         fontWeight: FontWeight.w600,
  //       ),
  //       text: dataValueText,
  //     );
  //     TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
  //
  //     tp.layout();
  //
  //     double dx = 10;
  //     double dy = coordinates[index].dy - (tp.height / 2);
  //
  //     Offset offset = Offset(dx, dy);
  //     tp.paint(canvas, offset);
  //   }
  // }

  void drawYLabels(Canvas canvas, Size size, List<Offset> coordinates) {
    double minValue = data.reduce(min);
    double maxValue = data.reduce(max);

    String minValueText = '${minValue.toInt()}';
    String maxValueText = '${maxValue.toInt()}';

    drawYText(canvas, "0", 18, size.height - 50);
    drawYText(canvas, "100", 18, size.height - 320);
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

    int indexOfMax = coordinates.indexWhere((offset) => offset.dy == coordinates.map((offset) => offset.dy).reduce(max));

    double dx = (size.width - tp.width) / 2;
    double dy = tp.height - 80;//coordinates[indexOfMax].dy - tp.height - 50;

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