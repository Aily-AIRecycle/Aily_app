import 'package:flutter/material.dart';
import 'StartPage.dart';
import 'GarbageCanPage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'MyApp',
    initialRoute: '/',
    routes: {
      '/': (context) => const StartPage(),
      '/GarbageCan': (context) => const GarbageCanPage(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

