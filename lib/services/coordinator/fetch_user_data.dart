import 'dart:convert';
 
import 'package:http/http.dart' as http;

 

class ManagerService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Change to your Django server URL
  Future<void> addManager(String userName, String userType, String email,
      String password, int departmentId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}users/'),
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

    if (response.statusCode != 201) {
      throw Exception('Failed to add manager');
    }
  }

  Future<void> updateManager(int? id, String userName, String userType,
      String email, String password, int departmentId) async {
    final response = await http.put(
      Uri.parse('${baseUrl}users/update/$id/'),
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

    if (response.statusCode == 200) {
      // If the server returns an OK response, navigate back or show a success message
    } else {
      // If the server did not return an OK response, throw an exception
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteManager(int id) async {
    final response =
        await http.delete(Uri.parse('${baseUrl}users/delete/$id/'));
    if (response.statusCode == 204) {
      // print('Task deleted successfully');
    } else {
      // print('Failed to add department: ${response.body}');
      throw Exception('Failed to add department: ${response.body}');
      // print('Failed to delete task: ${response.statusCode}');
    }
  }
}
