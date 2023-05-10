import 'package:geolocator/geolocator.dart';

class Location {
  static final Location _singleton = Location._internal();

  factory Location() {
    return _singleton;
  }

  Location._internal();

  Map<String, String> data = {};
  String searchStr = '';
  double latitude = 0;
  double longitude = 0;

  Future<void> getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      //
    }
  }
}