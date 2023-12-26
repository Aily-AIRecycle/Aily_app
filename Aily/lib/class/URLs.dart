class URL {
  static final URL _singleton = URL._internal();

  factory URL() {
    return _singleton;
  }

  URL._internal();
  String baseURL = 'https://ailymit.store/member';
  //로그인
  String get loginURL => '$baseURL/login';

  //프로필 변경
  String get imageURL => '$baseURL/upload';

  //닉네임 중복체크, 닉네임 변경
  String get nameChkURL => '$baseURL/ChNick';
  String get nameChangeURL => '$baseURL/UIC';

  //포인트 적립
  String get historypaxURL => '$baseURL/historypax';

  //포화도
  String get garbageURL => 'https://ailyproject.shop/api/garbage';

  //지도
  String get mapURL => 'https://ailyproject.shop/map';

  //회원가입, 이메일
  String get emailChkURL => "$baseURL/EmailCheck";
  String get emailAuthURL => "$baseURL/auth-email";
  String get joinURL => "$baseURL/join";

  //재활용
  String get typeURL => 'https://ailyproject.shop/api/type';
}

//재활용, 포화도