import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';

 
// departmentServicefromDjango

class DepartmentService {
 API api = API();
  Future<void> addDepartment(String departmentName) async {
await http.post(
      Uri.parse('${api.baseUrl}departments/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'department_name': departmentName,
      }),
    );

   
  }

  Future<void> updateDepartment(int? id, String departmentName) async {
     await http.put(
      Uri.parse('${api.baseUrl}departments/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'department_name': departmentName,
      }),
    );
  }

  Future<void> deleteTask(int id) async {
        await http.delete(Uri.parse('${api.baseUrl}departments/delete/$id/'));
  
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
