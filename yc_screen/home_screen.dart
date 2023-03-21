import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test_flutter/AccountPage.dart';
import 'package:test_flutter/ShowDialog.dart';
import 'FAQPage.dart';
import 'package:test_flutter/NoticePage.dart';
import 'dart:io';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  _MyScreenPageState createState() => _MyScreenPageState();
}

class _MyScreenPageState extends State<MyScreen> {
  late String phoneNumber;
  String _qrCode = '';

  late MySqlConnection conn;

  File? _image;
  Uint8List? _imageData, _downimageData;

  late String? username;
  late Uint8List? profile;
  @override
  void initState() {
    super.initState();
    MySqlConnection.connect(
      ConnectionSettings(
        host: '211.201.93.173',//'175.113.68.69',
        port: 3306,
        user: 'root',
        password: '488799',
        db: 'user_db',
      ),
    ).then((connection) {
      conn = connection;
    });
  }

  @override
  void dispose() {
    conn.close();
    super.dispose();
  }

  Future<void> _scanQRCode() async {
    String qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      '취소',
      true,
      ScanMode.QR,
    );

    setState(() {
      _qrCode = qrCode;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = File(pickedFile!.path);
        _imageData = bytes;
      });
    }
    if (_image == null) {
      return;
    }
    try {
      await uploadImageToServer(_image!);
    } catch (e) {
      showMsg(context, "오류", '업로드 실패');
    } finally {
    }
  }

  Future<void> uploadImageToServer(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final imgData = bytes.toList();

      final rows = await conn.query('SELECT username FROM sign WHERE username = ?', [username]);
      if (rows.isNotEmpty) {
        await conn.query(
          'UPDATE sign SET image = ? WHERE username = ?',
          [imgData, username],
        );
      } else {
        await conn.query(
          'INSERT INTO sign (username, image) VALUES (?, ?)',
          [username, imgData],
        );
      }
      downloadImageFromServer(username!);
    } catch (e) {
      showMsg(context, "오류", '업로드 실패: $e');
    }
  }

  Future<void> downloadImageFromServer(String id) async {
    try {
      final result = await conn.query('SELECT image FROM sign WHERE username = ?', [id]);
      if (result.isNotEmpty) {
        final rowData = result.first;
        final imgData = rowData['image'] as Blob;
        final bytes = imgData.toBytes();
        setState(() {
          //_downimageData = bytes as Uint8List?;
          profile = bytes as Uint8List?;
        });
      }
    } catch (e) {
      showMsg(context, "오류", '다운로드 실패');
    } finally {
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String phoneNumber = args["phoneNumber"];
    username = args["name"];
    profile = args["profile"];
    Color myColor = const Color(0xFFF8B195);
    Color backColor = const Color(0xFFF6F6F6);

    return Scaffold(
      backgroundColor: backColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 55),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        "AILY",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Waiting for the Sunrise',
                          fontWeight: FontWeight.bold,
                          color: myColor,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 280,
                      child: GestureDetector(
                        onTap: () {
                          // 클릭 시 실행될 코드
                          showMsg(context, "테스트", "테스트");
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/alarm.png', // 이미지 파일 경로
                              width: 40, // 이미지 크기
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게 만듭니다.
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 30,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/icons/wallet.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$username님의 포인트',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Center(
                      child: Text(
                        '2,222,222 P',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Expanded(
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           color: Colors.white,
            //           child: const Center(
            //             child: Text('화면1', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            //           ),
            //         ),
            //       ),
            //       const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            //       Expanded(
            //         child: Container(
            //           color: Colors.white,
            //           child: const Center(
            //             child: Text('화면2', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),
            // Expanded(
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           color: Colors.white,
            //           child: const Center(
            //             child: Text('화면3', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            //           ),
            //         ),
            //       ),
            //       const Padding(padding: EdgeInsets.symmetric(horizontal: 10.0)),
            //       Expanded(
            //         child: Container(
            //           color: Colors.white,
            //           child: const Center(
            //             child: Text('화면4', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Text('뭘 넣을까?', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 55),
          ],
        ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage(phoneNumber: phoneNumber)));
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
        onPressed: _scanQRCode,
        backgroundColor: myColor,
        highlightElevation: 0,
        splashColor: Colors.red,
        child: Image.asset('assets/images/QR.png', width: 30, height: 30),
      ),
    );
  }
}