class URL {
  static final URL _singleton = URL._internal();

  factory URL() {
    return _singleton;
  }

  URL._internal();
  String baseURL = 'https://ailyproject.shop';
  String get signURL => '$baseURL/api/sign';
  String get loginURL => '$baseURL/api/login';
  String get garbageURL => '$baseURL/api/garbage';
  String get imageURL => '$baseURL/api/image';
  String get pointURL => '$baseURL/api/point';
  String get mapURL => '$baseURL/map';
  String get authURL => '$baseURL/api/SignAuth';
  String get staticsURL => '$baseURL/api/statics';
  String get typeURL => '$baseURL/api/type';
}
