import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class ClassNotifier extends StateNotifier<List<FetchingClass>> {
  ClassNotifier() : super([]);

  Future<void> retrieveClass(ProviderContainer container) async {
    API api = API();
    try {
      final response = await http.get(Uri.parse('${api.baseUrl}classs/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingClass objects
        state = responseBody
            .map((noteMap) => FetchingClass.fromMap(noteMap))
            .toList();

        // Dispose the provider after data is fetched
        container.dispose(); // Dispose the provider container
      } else {
        // Handle non-200 status codes
        // print('Failed to load class: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving class: $e');
    }
  }
}

// Provider to access ClassNotifier
final classProvider =
    StateNotifierProvider<ClassNotifier, List<FetchingClass>>((ref) {
  return ClassNotifier();
});

// FetchingClass class definition
class FetchingClass {
  int classId;
  String className;
  String classType;
  int departmentId;
  String? requestedBy;
  String? givenTo;

  FetchingClass(
      {required this.classId,
      this.requestedBy,
      this.givenTo,
      required this.className,
      required this.classType,
      required this.departmentId});

  factory FetchingClass.fromMap(Map<String, dynamic> map) {
    return FetchingClass(
        classId: map['class_id'] ?? '',
        className: map['class_name'] ?? '',
        classType: map['class_type'] ?? '',
        departmentId: map['department_id'] ?? 0,
        requestedBy: map['requested_by'] ?? '',
        givenTo: map['given_to']);
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'class_id': classId,
      'class_name': className,
      'class_type': classType,
      'department_id': departmentId,
      'requested_by': requestedBy,
      'given_to': givenTo
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingClass(class_name: $className,class_id:$classId ,class_type:$classType, department_id: $departmentId , requested_by:$requestedBy,given_to:$givenTo)';
}
