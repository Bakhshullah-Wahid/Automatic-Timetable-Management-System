// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/department/fetch_department.dart';

// StateNotifier to manage department fetching state
class DepartmentNotifier extends StateNotifier<List<FetchingDepartment>> {
  DepartmentNotifier() : super([]);

  Future<void> retrieveDepartments() async {
    try {
      DepartmentService urlFetch = DepartmentService();
      final response =
          await http.get(Uri.parse('${urlFetch.baseUrl}departments/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingDepartment objects
        state = responseBody
            .map((noteMap) => FetchingDepartment.fromMap(noteMap))
            .toList();

        // Convert the state to a list of maps (dictionaries)
        List<Map<String, dynamic>> departmentList =
            state.map((dept) => dept.toMap()).toList();

        // Print just the list of dictionaries
      } else {
        print(
            'Failed to load departments with status code: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Request timed out. Please check your network connection.');
    } catch (e) {
      print('Error occurred: $e');
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
