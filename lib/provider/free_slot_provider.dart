import 'dart:convert';

import 'package:attms/widget/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage fetching free slots
class FreeSlotNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FreeSlotNotifier() : super([]);

  // Fetch free slots based on class ID
  Future<void> retrieveFreeSlots(int classId, ProviderContainer container) async {
    API api = API();
    final url = Uri.parse('${api.baseUrl}/class/$classId/');
    
    try {
      final response = await http.get(url);

      // Check for successful response (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body into a Map
        final Map<String, dynamic> data = json.decode(response.body);

        // Safely handle the 'free_slots' key, fallback to empty list if not found
        final List<dynamic> freeSlots = data['free_slots'] ?? [];

        // Convert free slots data into a list of maps
        final List<Map<String, dynamic>> formattedFreeSlots = freeSlots.map((slot) {
          return {
            'id': slot['id'],
            'free_slots': slot['free_slots'],
            'day_of_week': slot['day_of_week'],
          };
        }).toList();

        // Update the state with formatted free slots
        state = formattedFreeSlots;

        // Dispose the container if needed
        container.dispose();
      } else {
        throw Exception(
            'Failed to load free slots. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching free slots: $e');
    }
  }
}

// Provider to access FreeSlotNotifier
final freeSlotProvider =
    StateNotifierProvider<FreeSlotNotifier, List<Map<String, dynamic>>>((ref) {
  return FreeSlotNotifier();
});


// Usage of FreeSlotNotifier in your widget

