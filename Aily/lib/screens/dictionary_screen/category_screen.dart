import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dictionary_screen.dart';

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
                  children: List.generate(9, (index) {
                    String categoryName;
                    AssetImage categoryIcon;
                    switch (index + 1) {
                      case 1:
                        categoryName = '일반쓰레기';
                        categoryIcon = const AssetImage('assets/images/icons/gen.png');
                        break;
                      case 2:
                        categoryName = '캔류·고철';
                        categoryIcon = const AssetImage('assets/images/icons/can.png');
                        break;
                      case 3:
                        categoryName = '페트';
                        categoryIcon = const AssetImage('assets/images/icons/pet.png');
                        break;
                      case 4:
                        categoryName = '종이·종이팩';
                        categoryIcon = const AssetImage('assets/images/icons/paper.png');
                        break;
                      case 5:
                        categoryName = '유리';
                        categoryIcon = const AssetImage('assets/images/icons/glass.png');
                        break;
                      case 6:
                        categoryName = '비닐';
                        categoryIcon = const AssetImage('assets/images/icons/vinyl.png');
                        break;
                      case 7:
                        categoryName = '플라스틱';
                        categoryIcon = const AssetImage('assets/images/icons/plastic.png');
                        break;
                      case 8:
                        categoryName = '음식물';
                        categoryIcon = const AssetImage('assets/images/icons/garbage.png');
                        break;
                      case 9:
                        categoryName = '의류·원단';
                        categoryIcon = const AssetImage('assets/images/icons/close.png');
                        break;
                      default:
                        categoryName = '';
                        categoryIcon = const AssetImage('assets/images/icons/gen.png');
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
                            Image(
                              width: 50,
                              height: 50,
                              image: categoryIcon,
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