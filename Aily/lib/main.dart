import 'package:aily/screens/home_screen/home_screen.dart';
import 'package:aily/screens/navigator_screen/navigator.dart';
import 'package:aily/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        MaterialApp(
          home: const Scaffold(
            backgroundColor: Colors.white,
            body: NavigatorScreen(),//SplashScreen(),
          ),
          theme: ThemeData(
            fontFamily: 'Pretendard',
            useMaterial3: false,
          ),
          debugShowCheckedModeBanner: false,
        ),
      );
      
    },
  );
}
