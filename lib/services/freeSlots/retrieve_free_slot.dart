import 'dart:convert';

import 'package:attms/widget/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

Future<dynamic> fetchFreeSlots(int classId, ProviderContainer container) async {
  API api = API();
  final url = Uri.parse('${api.baseUrl}class/$classId/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> freeSlots = await data['free_slots'] ?? [];
    freeSlots.map((slot) {
      return {
        'id': slot['id'],
        'free_slots': slot['free_slots'],
        'day_of_week': slot['day_of_week'],
      };
    }).toList();
    container.dispose();
    return freeSlots;
  } else {
    throw Exception(
        'Failed to load free slots. Status code: ${response.statusCode}');
  }
}
