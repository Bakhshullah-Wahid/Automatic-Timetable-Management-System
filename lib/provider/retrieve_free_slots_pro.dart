import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class FreeSlotNotifier extends StateNotifier<List<FetchingFreeSlot>> {
  FreeSlotNotifier() : super([]);

  Future<void> retrieveFreeSlots() async {
    
      API api = API();
      try{
      final response =
          await http.get(Uri.parse('${api.baseUrl}free-class/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingFreeSlot.fromMap(noteMap))
            .toList();
      } else {
        // Handle non-200 status codes
        // print('Failed to load free-slot: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving free-slot: $e');
    }
  
  
  }
}

// Provider to access freeSlotNotifier
final freeSlotProvider =
    StateNotifierProvider<FreeSlotNotifier, List<FetchingFreeSlot>>((ref) {
  return FreeSlotNotifier();
});

// FetchingFreeSlot class definition
class FetchingFreeSlot {
  int id;
  int classId;
  String freeSlots;
  int departmentId;
  String requestConfirmation;

  FetchingFreeSlot(
      {required this.classId,
      required this.requestConfirmation,
      required this.id,
      required this.departmentId,
      required this.freeSlots});

  factory FetchingFreeSlot.fromMap(Map<String, dynamic> map) {
    return FetchingFreeSlot(
      id: map['id'] ?? 0,
      classId: map['class_id'] ?? 0,
      freeSlots: map['free_slots'] ?? '',
      departmentId: map['department_id'] ?? 0,
      requestConfirmation:map['request_confirmation']??''
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'class_id': classId,
      'free_slots': freeSlots,
      'department_id': departmentId,
      'requst_confirmation':requestConfirmation
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingFreeSlot(class_id: $classId,id:$id ,free_slots:$freeSlots, department_id: $departmentId , request_confirmation: $requestConfirmation)';
}
