import 'dart:convert';
 
import 'package:http/http.dart' as http;

import '../../widget/base_api.dart'; 
class SubjectService {
  API api = API();
  Future<void> addSubject(
    String semester,  String subjectName, String courseModule, int? teacherId , int theory ,int lab,int departmentId) async {
   await http.post(
      Uri.parse('${api.baseUrl}subjects/'),
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
  }

  Future<void> updateSubject(String semester,
      int? id, String subjectName, String courseModule, dynamic departmentId , dynamic teacherId , int lab , int theory) async {
await http.put(
      Uri.parse('${api.baseUrl}subjects/update/$id/'),
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
  }

  Future<void> deleteSubject(int id) async {
    
        await http.delete(Uri.parse('${api.baseUrl}subjects/delete/$id/'));
  }
}

