import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';

class TeacherService {
  API api = API();
  Future<void> addTeacher(
      String teacherName, String email, int departmentId) async {
    await http.post(
      Uri.parse('${api.baseUrl}teachers/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'teacher_name': teacherName,
        'email': email,
        'department_id': departmentId
      }),
    );
  }

  Future<void> updateTeacher(
      int? id, String teacherName, String email, dynamic departmentId ,String requestedBy , String givenTo) async {
    await http.put(
      Uri.parse('${api.baseUrl}teachers/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'teacher_name': teacherName,
        'email': email,
        'department_id': departmentId, // Change here
        'requested_by':requestedBy,
        'given_to':givenTo
      }),
    );
  }

  Future<void> deleteClass(int id) async {
    await http.delete(Uri.parse('${api.baseUrl}teachers/delete/$id/'));
  }
}
