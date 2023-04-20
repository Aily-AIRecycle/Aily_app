import 'package:Aily/class/testUser.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class UserProvider with ChangeNotifier {
  final User _user = User(nickname: '', point: 0, image: File(''), phonenumber: 0);

  User get user => _user;

  void updateNickname(String nickname) {
    _user.updateNickname(nickname);
    notifyListeners();
  }

  void updatePoint(int point) {
    _user.updatePoint(point);
    notifyListeners();
  }

  void updateImage(File image) {
    _user.updateImage(image);
    notifyListeners();
  }

  void updatePhoneNumber(int phonenumber) {
    _user.updatePhoneNumber(phonenumber);
    notifyListeners();
  }
}
