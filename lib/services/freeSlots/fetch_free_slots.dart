import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';

//ClassServicefromDjango

class FreeSlotServices {
  API api = API(); // Change to your Django server URL
  Future<bool> addFreeSlot(int classId, String freeSlots, int departmentId,
      String daysOfWeek) async {
    try {
        await http.post(
        Uri.parse('${api.baseUrl}free-class/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'class_id': classId,
          'free_slots': freeSlots,
          'department_id': departmentId,
          'day_of_week': daysOfWeek
        }),
      );
    
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateFreeSlots(
    int? id,
    int classId,
    String freeSlots,
    dynamic departmentId,
  ) async {
    if (id == null) {
      throw Exception('ID must not be null');
    }
    if (departmentId == null) {
      throw Exception('Department must not be null');
    }

    final response = await http.put(
      Uri.parse('${api.baseUrl}free-class/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'class_id': classId,
        'free_slots': freeSlots,
        'department_id': departmentId
      }),
    );

    if (response.statusCode == 200) {
      // Success
    } else {
      throw Exception('Failed to update class: ${response.body}');
    }
  }

  Future<bool> deleteFreeSlot(
      int classId, String slot, String dayOfWeek) async {
    try {
      await http.delete(
          Uri.parse('${api.baseUrl}class/delete/$classId/$slot/$dayOfWeek/'));
      return true;
    } catch (e) {
      return false;
    }
  }
}
