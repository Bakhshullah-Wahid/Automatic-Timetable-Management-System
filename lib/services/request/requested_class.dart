import 'dart:convert';

import 'package:http/http.dart' as http;

class ClassRequestService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Replace with your Django backend URL

  // Method to add a new class request
  Future<void> addClassRequest(String status, String requesterDepartment,
      String requestedClass, dateCreated, purpose) async {
    final response = await http.post(
      Uri.parse(
          '${baseUrl}class-request/'), // Ensure this endpoint matches your Django URL for creating class requests
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'status': status,
        'department_id': requesterDepartment,
        'class_id': requestedClass,
        'created_at': dateCreated,
        'purpose': purpose,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add class request');
    }
  }

  // Method to update an existing class request
  Future<void> updateClassRequest(int? id, String status, String requestedClass,
      String requesterDepartment, dateCreated, purpose) async {
    if (id == null) {
      throw Exception('ID must not be null');
    }

    final response = await http.put(
      Uri.parse(
          '${baseUrl}class-requests/update/$id/'), // Ensure this matches your Django URL for updating class requests
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
        'department_id': requesterDepartment,
        'class_id': requestedClass,
        'created_at': dateCreated,
        'purpose': purpose,
      }),
    );

    if (response.statusCode == 200) {
      // Success, handle as necessary
    } else {
      throw Exception('Failed to update class request: ${response.body}');
    }
  }

  // Method to delete a class request
  Future<void> deleteClassRequest(int id) async {
    final response = await http.delete(Uri.parse(
        '${baseUrl}class-request/delete/$id/')); // Ensure this matches your Django URL for deleting class requests
    if (response.statusCode == 204) {
      // Successfully deleted class request
    } else {
      throw Exception('Failed to delete class request: ${response.statusCode}');
    }
  }

  // Method to fetch all class requests
  Future<List<Map<String, dynamic>>> fetchClassRequests() async {
    final response = await http.get(Uri.parse(
        '${baseUrl}class-requests/')); // Ensure this endpoint matches your Django URL for fetching class requests
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((requestMap) {
        return {
          'id': requestMap['id'],
          'purpose': requestMap['purpose'],
          'class_id': requestMap['class_id'],
          'department_id': requestMap['department_id'],
          'status': requestMap['status'], // Assume there's a status field
          'created_at': requestMap[
              'created_at'], // Assuming a timestamp for when the request was made
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch class requests');
    }
  }
}
