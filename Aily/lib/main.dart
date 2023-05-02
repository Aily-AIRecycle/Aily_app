import 'package:Aily/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(
    MaterialApp(
      home: const LoginScreen(),
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
