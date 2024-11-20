import 'dart:convert';

import 'package:http/http.dart' as http;

// departmentServicefromDjango

class TeacherService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Change to your Django server URL
  Future<void> addTeacher(
      String teacherName, String email, int departmentId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}teachers/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'teacher_name': teacherName,
        'email': email,
        'department_id': departmentId
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add Teacher');
    }
  }

  Future<void> updateTeacher(
      int? id, String teacherName, String email, dynamic departmentId) async {
    if (id == null) {
      throw Exception('ID must not be null');
    }
    if (departmentId == null) {
      throw Exception('Teacher must not be null');
    }

    final response = await http.put(
      Uri.parse('${baseUrl}teachers/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'teacher_name': teacherName,
        'email': email,
        'department_id': departmentId, // Change here
      }),
    );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Success
    } else {
      throw Exception('Failed to update class: ${response.body}');
    }
  }

  Future<void> deleteClass(int id) async {
    final response =
        await http.delete(Uri.parse('${baseUrl}teachers/delete/$id/'));
    if (response.statusCode == 204) {
      // print('Teacher deleted successfully');
    } else {
      // print('Failed to delete task: ${response.statusCode}');
    }
  }
}

// class DepartmentFetching {
//   int departmentId; // Make id nullable
//   String departmentName;

//   DepartmentFetching({
//     required this.departmentId, // No need to use 'required' for a nullable type
//     required this.departmentName,
//   });

//   factory DepartmentFetching.fromMap(Map<String, dynamic> map) {
//     return DepartmentFetching(
//         departmentId: map['department_id'], // Check for null
//         departmentName: map['department_name'] // Fallback if null
//         );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'department_id': departmentId,
//       'department_name': departmentName,
//     };
//   }

//   String toJson() => json.encode(toMap());
// }
