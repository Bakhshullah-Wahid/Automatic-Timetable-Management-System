import 'dart:convert';
 
import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';
class ManagerService {
   API api = API();
  Future<void> addManager(String userName, String userType, String email,
      String password, int departmentId) async {
    await http.post(
      Uri.parse('${api.baseUrl}users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_name': userName,
        'user_type': userType,
        'password': password,
        'email': email,
        'department_id': departmentId
      }),
    );

    
  }

  Future<void> updateManager(int? id, String userName, String userType,
      String email, String password, int departmentId) async {
     await http.put(
      Uri.parse('${api.baseUrl}users/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_name': userName,
        'user_type': userType,
        'password': password,
        'email': email,
        'department_id': departmentId
      }),
    );
  }

  Future<void> deleteManager(int id) async {
  
        await http.delete(Uri.parse('${api.baseUrl}users/delete/$id/'));
  }
}
