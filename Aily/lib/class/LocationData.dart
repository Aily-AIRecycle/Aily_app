class LocationData {
  static final LocationData _singleton = LocationData._internal();

  factory LocationData() {
    return _singleton;
  }

  LocationData._internal();

  Map<String, String> data = {};
  String searchStr = '';
}
