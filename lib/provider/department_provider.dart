// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class DepartmentNotifier extends StateNotifier<List<FetchingDepartment>> {
  DepartmentNotifier() : super([]);

  Future<void> retrieveDepartments(ProviderContainer container) async {
    API api = API();
    try{
    final response = await http.get(Uri.parse('${api.baseUrl}departments/'));
     if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingDepartment.fromMap(noteMap))
            .toList();container.dispose();
      } else {
        // Handle non-200 status codes
        // print('Failed to load departments: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving departments: $e');
    }
  }
}

// Provider to access DepartmentNotifier
final departmentProvider =
    StateNotifierProvider<DepartmentNotifier, List<FetchingDepartment>>((ref) {
  return DepartmentNotifier();
});

// FetchingDepartment class definition
class FetchingDepartment {
  final String departmentName;
  final int departmentId;

  FetchingDepartment({
    required this.departmentName,
    required this.departmentId,
  });

  factory FetchingDepartment.fromMap(Map<String, dynamic> map) {
    return FetchingDepartment(
      departmentName: map['department_name'] ?? '',
      departmentId: map['department_id'] ?? 0,
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'department_name': departmentName,
      'department_id': departmentId,
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingDepartment(department_name: $departmentName, department_id: $departmentId)';
}
