import 'dart:convert';

import 'package:http/http.dart' as http;

String apiUrl = 'https://kitsu.io/api/edge/anime/?page[limit]=20&page[offset]=0';

Future<List<dynamic>> getShows() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data']; 
  } else {
    throw Exception('Failed to load shows');
  }
}

Future<Map<String, dynamic>> getSingleShow(String showId) async {
  final response = await http.get(Uri.parse('$apiUrl/$showId'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];        // berupa Map
  } else {
    throw Exception('Failed to load show detail');
  }
}

