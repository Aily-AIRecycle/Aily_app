import 'dart:io';

class User {
  String nickname;
  int point;
  File image;
  int phonenumber;

  User({
    required this.nickname,
    required this.point,
    required this.image,
    required this.phonenumber,
  });

  void updateNickname(String nickname) {
    this.nickname = nickname;
  }

  void updatePoint(int point) {
    this.point = point;
  }

  void updateImage(File image) {
    this.image = image;
  }

  void updatePhoneNumber(int phonenumber) {
    this.phonenumber = phonenumber;
  }
}
