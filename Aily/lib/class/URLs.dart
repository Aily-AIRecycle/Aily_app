class URL {
  static final URL _singleton = URL._internal();

  factory URL() {
    return _singleton;
  }

  URL._internal();
  String baseURL = 'https://ailyproject.shop';
  //로그인
  String get loginURL => 'https://ailymit.store/member/member/login';

  //프로필 변경
  String get imageURL => 'https://ailymit.store/member/member/upload';

  //닉네임 중복체크, 닉네임 변경
  String get namechkURL => 'https://ailymit.store/member/member/ChNick';
  String get namechangeURL => 'https://ailymit.store/member/member/UIC';

  //포인트 적립
  String get staticsURL => 'https://ailymit.store/member/member/historypax';

  //포화도
  String get garbageURL => '$baseURL/api/garbage';

  //포인트
  String get pointURL => '$baseURL/api/point';

  //지도
  String get mapURL => '$baseURL/map';

  //회원가입, 이메일
  String get signURL => '$baseURL/api/sign';
  String get authURL => '$baseURL/api/SignAuth';

  //재활용
  String get typeURL => '$baseURL/api/type';
}
