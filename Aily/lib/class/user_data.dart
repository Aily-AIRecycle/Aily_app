import 'dart:io';
import 'package:intl/intl.dart';

class UserData {
  static final UserData _singleton = UserData._internal();

  factory UserData() {
    return _singleton;
  }

  String formatInt(int point){
    return NumberFormat('#,###').format(point);
  }

  UserData._internal();
  String? email = '';
  String? password = '';
  String? nickname = '';
  String? birth = '';
  int? point = 0;
  int? phonenumber = 0;
  File? profile = File('');
}
