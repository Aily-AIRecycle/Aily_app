import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(
            0xffF8B195,
          ),
          title: Text('Aily'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 300,
                    height: 80,
                    child: Text(
                      '홍대입구역 Aily',
                      style: TextStyle(
                        color: Color(
                          0xff353E5E,
                        ),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ), // 홍대입구역 로우
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  width: 120,
                  child: Text(
                    '상세정보 >',
                    style: TextStyle(
                        color: Color(
                          0xff353E5E,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ), // 상세정보 로우
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 307,
                  height: 215,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Color(0xffF8B195),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '일반',
                    style: TextStyle(
                      color: Color(
                        0xff353E5E,
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '캔',
                    style: TextStyle(
                      color: Color(
                        0xff353E5E,
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '플라스틱',
                    style: TextStyle(
                      color: Color(
                        0xff353E5E,
                      ),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ), // 텍스트 로우
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F2F2),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35.0),
                      bottom: Radius.circular(35.0),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xffF8B195),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(35.0),
                      bottom: Radius.circular(35.0),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F2F2),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                      bottom: Radius.circular(25.0),
                    ),
                  ),
                ),
              ],
            ),

          ],

        ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        elevation: 0,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {},
              tooltip: 'home',
              iconSize: 30,
              color: Colors.grey,
              icon: const Icon(Icons.home),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/GarbageCan');
              },
              tooltip: 'contents',
              iconSize: 30,
              color: Colors.grey,
              icon: const Icon(Icons.content_paste),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              tooltip: 'location',
              iconSize: 30,
              color: Colors.grey,
              icon: const Icon(Icons.location_on),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {


              },
              tooltip: 'person',
              iconSize: 30,
              color: Colors.grey,
              icon: const Icon(Icons.person),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Color(0xffF8B195),
        highlightElevation: 0,
        splashColor: Colors.red,
        child: Image.asset('assets/images/QR.png', width: 30, height: 30),
      ),
    );
  }
}
