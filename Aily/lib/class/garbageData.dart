import 'dart:convert';
import 'package:http/http.dart' as http;
import '../class/URLs.dart';

class GarbageData {
  final String merch;
  final int no;
  final int ca;
  final int pl;
  final bool status;

  GarbageData({required this.merch, required this.no, required this.ca, required this.pl, required this.status});

  factory GarbageData.fromJson(Map<String, dynamic> json) {
    return GarbageData(
        merch: json['merch'],
        no: json['no'],
        ca: json['ca'],
        pl: json['pl'],
        status: json['status']
    );
  }
}

Future<List<GarbageData>> fetchGarbage() async {
  final response = await http.get(Uri.parse(URL().garbageURL));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body)['garbage'];
    return jsonResponse.map((e) => GarbageData.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load garbage data');
  }
}