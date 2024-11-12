import 'dart:convert';
 
import 'package:http/http.dart' as http; 
 

//ClassServicefromDjango

class ClassService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Change to your Django server URL
  Future<void> addClass(
      String className, String classType, int departmentId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}classs/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'class_name': className,
        'class_type': classType,
        'department_id': departmentId
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add department');
    }
  }

  Future<void> updateClass(
      int? id, String className, String classType, dynamic departmentId) async {
    if (id == null) {
      throw Exception('ID must not be null');
    }
    if (departmentId == null) {
      throw Exception('Department must not be null');
    }

    final response = await http.put(
      Uri.parse('${baseUrl}classs/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'class_name': className,
        'class_type': classType,
        'department_id': departmentId, // Change here
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Success
    } else {
      throw Exception('Failed to update class: ${response.body}');
    }
  }

  Future<void> deleteClass(int id) async {
    final response =
        await http.delete(Uri.parse('${baseUrl}classs/delete/$id/'));
    if (response.statusCode == 204) {
      print('Task deleted successfully');
    } else {
      print('Failed to delete task: ${response.statusCode}');
    }
  }
}

// class ClassFetching {
//   int classId;
//   String className;
//   String classType;
//   final int? departmentId;

//   ClassFetching(
//       {required this.classId, // No need to use 'required' for a nullable type
//       required this.className,
//       required this.classType,
//       required this.departmentId});

//   factory ClassFetching.fromMap(Map<String, dynamic> map) {
//     return ClassFetching(
//         classId: map['class_id'], // Check for null
//         className: map['class_name'], // Fallback if null
//         classType: map['class_type'],
//         departmentId: map['department_id']);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'class_id': classId,
//       'class_name': className,
//       'class_type': classType,
//       'department_id': departmentId
//     };
//   }

//   String toJson() => json.encode(toMap());
// }
