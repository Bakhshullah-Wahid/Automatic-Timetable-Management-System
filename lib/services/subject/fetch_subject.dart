import 'dart:convert';
 
import 'package:http/http.dart' as http; 
 

//ClassServicefromDjango

class SubjectService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Change to your Django server URL
  Future<void> addSubject(
    String semester,  String subjectName, String courseModule, int teacherId , int theory ,int lab,int departmentId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}subjects/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'semester':semester,
        'subject_name': subjectName,
        'course_module': courseModule,
        'department_id': departmentId,
        'lab':lab,
        'theory':theory, 
        'teacher_id':teacherId
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add department');
    }
  }

  Future<void> updateSubject(String semester,
      int? id, String subjectName, String courseModule, dynamic departmentId , dynamic teacherId , int lab , int theory) async {
    if (id == null) {
      throw Exception('ID must not be null');
    }
    if (departmentId == null) {
      throw Exception('Department must not be null');
    }

    final response = await http.put(
      Uri.parse('${baseUrl}subjects/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'semester':semester,
        'subject_name': subjectName,
        'course_module': courseModule,
        'department_id': departmentId,
        'lab':lab,
        'theory':theory, 
        'teacher_id':teacherId, // Change here
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

  Future<void> deleteSubject(int id) async {
    final response =
        await http.delete(Uri.parse('${baseUrl}subjects/delete/$id/'));
    if (response.statusCode == 204) {
      print('Task deleted successfully');
    } else {
      print('Failed to delete task: ${response.statusCode}');
    }
  }
}

