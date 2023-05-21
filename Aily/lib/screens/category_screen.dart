import 'package:Aily/utils/ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/dictionary_screen.dart';

class categoryScreen extends StatefulWidget {
  const categoryScreen({Key? key}) : super(key: key);

  @override
  _categoryScreenState createState() => _categoryScreenState();
}

class _categoryScreenState extends State<categoryScreen> {
  Color myColor = const Color(0xFFF8B195);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CategoryWidget(context)
    );
  }

  Widget CategoryWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 72, left: 24, right: 24, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      '재활용 사전',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children: List.generate(12, (index) {
                    String categoryName;
                    IconData categoryIcon;
                    Color categoryColors = Color(0);
                    switch (index + 1) {
                      case 1:
                        categoryName = '일반쓰레기';
                        categoryIcon = Icons.delete;
                        categoryColors = Colors.blueAccent;
                        break;
                      case 2:
                        categoryName = '캔류·고철';
                        categoryIcon = Icons.cached;
                        categoryColors = Colors.blueGrey;
                        break;
                      case 3:
                        categoryName = '페트';
                        categoryIcon = Icons.pets;
                        categoryColors = Colors.green;
                        break;
                      case 4:
                        categoryName = '종이·종이팩';
                        categoryIcon = Icons.book;
                        categoryColors = Colors.grey;
                        break;
                      case 5:
                        categoryName = '유리';
                        categoryIcon = Icons.ac_unit_sharp;
                        categoryColors = Colors.grey.shade300;
                        break;
                      case 6:
                        categoryName = '비닐';
                        categoryIcon = Icons.clear_all;
                        categoryColors = Colors.grey.shade400;
                        break;
                      case 7:
                        categoryName = '플라스틱';
                        categoryIcon = Icons.bubble_chart;
                        categoryColors = Colors.orange;
                        break;
                      case 8:
                        categoryName = '음식물';
                        categoryIcon = Icons.restaurant_menu;
                        categoryColors = Colors.lightGreen;
                        break;
                      case 9:
                        categoryName = '의류·원단';
                        categoryIcon = Icons.accessibility_new;
                        categoryColors = Colors.pinkAccent;
                        break;
                      default:
                        categoryName = '';
                        categoryIcon = Icons.error;
                    }
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        // 클릭 이벤트 처리
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => dictionaryScreen(title: categoryName, type: index+1),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              categoryIcon,
                              size: 48,
                              color: categoryColors
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categoryName,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}