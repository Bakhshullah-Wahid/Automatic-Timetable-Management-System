import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';

//ClassServicefromDjango

class ClassService {
  API api = API();
  Future<void> addClass(String className, String classType, int departmentId,
      ) async {
   await http.post(
      Uri.parse('${api.baseUrl}classs/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'class_name': className,
        'class_type': classType,
        'department_id': departmentId,
        
      }),
    );
  }

  Future<void> updateClass(int? id, String className, String classType,
      dynamic departmentId) async {
 await http.put(
      Uri.parse('${api.baseUrl}classs/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'class_name': className,
        'class_type': classType,
        'department_id': departmentId,
        
        // Change here
      }),
    );
  }

  Future<void> deleteClass(int id) async {
        await http.delete(Uri.parse('${api.baseUrl}classs/delete/$id/'));
    
  }
}
