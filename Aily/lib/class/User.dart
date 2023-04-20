import 'dart:io';

class User {
  final String username;
  final File? profile;

  User({required this.username, required this.profile});

  factory User.withDefaultProfile({required String username}) {
    return User(
      username: username,
      profile: null
    );
  }
}
