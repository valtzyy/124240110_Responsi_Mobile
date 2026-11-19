import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'https://kitsu.io/api/edge/anime';

Future<List<dynamic>> getShows() async {
  final response =
      await http.get(Uri.parse('$baseUrl/?page[limit]=20&page[offset]=0'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];
  } else {
    throw Exception('Failed to load shows');
  }
}

Future<Map<String, dynamic>> getSingleShow(String showId) async {
  final response = await http.get(Uri.parse('$baseUrl/$showId'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];
  } else {
    throw Exception('Failed to load show detail');
  }
}
