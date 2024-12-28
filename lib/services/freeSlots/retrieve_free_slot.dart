import 'dart:convert';

import 'package:attms/widget/base_api.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchFreeSlots(int classId) async {
  // const String baseUrl = 'http://127.0.0.1:8000/';
  API api = API();
  final url = Uri.parse('${api.baseUrl}/class/$classId/');
  // Send GET request to fetch data from the server
  final response = await http.get(url);

  // Check for successful response (status code 200)
  if (response.statusCode == 200) {
    // Parse the response body into a Map
    final Map<String, dynamic> data = json.decode(response.body);

    // Safely handle the 'free_slots' key, fallback to empty list if not found
    final List<dynamic> freeSlots = data['free_slots'] ?? [];

    // Return a list of maps containing 'id', 'free_slots', and 'day' for each free slot
    return freeSlots.map((slot) {
      return {
        'id': slot['id'],
        'free_slots': slot['free_slots'],
        'day_of_week': slot['day_of_week'],
      };
    }).toList();
  } else {
    // Throw an exception if the response status is not successful
    throw Exception(
        'Failed to load free slots. Status code: ${response.statusCode}');
  }
}
