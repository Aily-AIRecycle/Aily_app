import 'package:dio/dio.dart';
import 'urls.dart';

class GarbageData {
  final int can;
  final String merch;
  final int gen;
  final int pet;
  final int status;

  GarbageData({
    required this.can,
    required this.merch,
    required this.gen,
    required this.pet,
    required this.status,
  });

  factory GarbageData.fromJson(Map<String, dynamic> json) {
    return GarbageData(
      can: json['can'] as int,
      merch: json['merch'] as String,
      gen: json['gen'] as int,
      pet: json['pet'] as int,
      status: json['status'] as int,
    );
  }
}

class GarbageMerch {
  static final GarbageMerch _singleton = GarbageMerch._internal();

  factory GarbageMerch() {
    return _singleton;
  }

  GarbageMerch._internal();
  String? merch = '';
}

Future<List<GarbageData>> fetchGarbage(String merch) async {
  Dio dio = Dio();

  try {
    Response<dynamic> response = await dio.post(
      URL().garbageURL,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
      data: {
        'merch': merch
      },
    );

    if (response.statusCode == 200) {
      final jsonData = response.data as Map<String, dynamic>;
      final garbageItemsData = jsonData['garbage'] as List<dynamic>;

      final List<GarbageData> garbageItems = garbageItemsData
          .map((item) => GarbageData.fromJson(item))
          .toList();

      return garbageItems;
    } else {
      throw Exception('Failed to fetch garbage');
    }
  } catch (error) {
    rethrow;
  }
}