import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../class/user_data.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  QRScreenState createState() => QRScreenState();
}

class QRScreenState extends State<QRScreen> {
  Color myColor = const Color(0xFFF8B195);
  int? phonenumber;

  @override
  void initState() {
    super.initState();
    _getPhone();
  }

  Future<void> _getPhone() async {
    UserData user = UserData();
    setState(() {
      phonenumber = user.phonenumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final qrSize = screenWidth * 0.6;
    final qrCode = QrImageView(
      data: "0$phonenumber",
      version: QrVersions.auto,
      size: qrSize,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('QR Code', style: TextStyle(color: Colors.black)),
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
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '전화번호 : 0$phonenumber',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              qrCode,
            ],
          ),
        ),
      ),
    );
  }
}