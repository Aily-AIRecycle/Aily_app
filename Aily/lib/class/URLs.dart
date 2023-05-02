class URL {
  static final URL _singleton = URL._internal();

  factory URL() {
    return _singleton;
  }

  URL._internal();

  String signURL = 'http://211.201.93.173:8080/api/sign';
  String loginURL = 'http://211.201.93.173:8081/api/login';
  String garbageURL = 'http://211.201.93.173:8082/api/garbage';
  String imageURL = 'http://211.201.93.173:8083/api/image';
  String mapURL = 'http://211.201.93.173:8084/map';
}
