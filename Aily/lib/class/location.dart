import 'dart:async';
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

  final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
  );

  Future<void> getCurrentLocation() async {
    StreamSubscription<Position> positionStream;
    try {
      positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position newPosition) {
        // 위치 업데이트를 받아온 후에 필요한 로직을 수행하세요
        latitude = newPosition.latitude;
        longitude = newPosition.longitude;
      });
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.bestForNavigation);
      // latitude = position.latitude;
      // longitude = position.longitude;

    } catch (e) {
      //
    }
  }
}