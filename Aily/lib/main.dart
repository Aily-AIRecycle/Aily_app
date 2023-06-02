import 'package:aily/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MaterialApp(
        home: const LoginScreen(),
        theme: ThemeData(
          fontFamily: 'Pretendard',
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
    FlutterNativeSplash.remove();
  });
}