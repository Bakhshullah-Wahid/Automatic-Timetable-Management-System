import 'dart:convert';
import 'package:http/http.dart' as http;

 
// departmentServicefromDjango

class DepartmentService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Change to your Django server URL
  Future<void> addDepartment(String departmentName) async {
    final response = await http.post(
      Uri.parse('${baseUrl}departments/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'department_name': departmentName,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add department');
    }
  }

  Future<void> updateDepartment(int? id, String departmentName) async {
    final response = await http.put(
      Uri.parse('${baseUrl}departments/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'department_name': departmentName,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, navigate back or show a success message
    } else {
      // If the server did not return an OK response, throw an exception
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteTask(int id) async {
    final response =
        await http.delete(Uri.parse('${baseUrl}departments/delete/$id/'));
    if (response.statusCode == 204) {
      // print('Task deleted successfully');
    } else {
      // print('Failed to delete task: ${response.statusCode}');
    }
  }
}

class DepartmentFetching {
  int departmentId; // Make id nullable
  String departmentName;

  DepartmentFetching({
    required this.departmentId, // No need to use 'required' for a nullable type
    required this.departmentName,
  });

  factory DepartmentFetching.fromMap(Map<String, dynamic> map) {
    return DepartmentFetching(
        departmentId: map['department_id'], // Check for null
        departmentName: map['department_name'] // Fallback if null
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'department_id': departmentId,
      'department_name': departmentName,
    };
  }

  String toJson() => json.encode(toMap());
}
