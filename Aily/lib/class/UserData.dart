import 'dart:io';

class UserData {
  static final UserData _singleton = UserData._internal();

  factory UserData() {
    return _singleton;
  }

  UserData._internal();

  String? nickname = '';
  int? point = 0;
  int? phonenumber = 0;
  File? profile = File('');
}
