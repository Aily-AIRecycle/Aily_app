import 'package:Aily/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'proves/testUserProvider.dart';
import 'proves/mapTitleProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TitleProvider()),
        ],
        child:MaterialApp(
          home: const LoginScreen(),
          theme: ThemeData(
            fontFamily: 'Pretendard',
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    ),
  );
}
