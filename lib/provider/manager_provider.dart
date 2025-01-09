// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class ManagerNotifier extends StateNotifier<List<FetchingManager>> {
  ManagerNotifier() : super([]);

  Future<void> retrieveManager(int? departmentId) async {
    API api = API(); 
    try {
      final response = departmentId != null
          ? await http.get(Uri.parse('${api.baseUrl}users/$departmentId/'))
          : await http.get(Uri.parse('${api.baseUrl}users/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingManager.fromMap(noteMap))
            .toList();
      } else {
        // Handle non-200 status codes
        // print('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving user: $e');
    }
  }
}

// Provider to access ManagerNotifier
final managerProvider =
    StateNotifierProvider<ManagerNotifier, List<FetchingManager>>((ref) {
  return ManagerNotifier();
});

// FetchingManager class definition
class FetchingManager {
  final int userId;
  final String userName;
  final String userType;
  final String email;
  final String password;
  final int departmentId;

  FetchingManager({
    required this.userId,
    required this.email,
    required this.userType,
    required this.password,
    required this.userName,
    required this.departmentId,
  });

  factory FetchingManager.fromMap(Map<String, dynamic> map) {
    return FetchingManager(
      userId: map['user_id'] ?? 0,
      email: map['email'] ?? '',
      userType: map['user_type'] ?? '',
      password: map['password'] ?? '',
      userName: map['user_name'] ?? '',
      departmentId: map['department_id'] ?? 0,
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      "user_id": userId,
      "user_name": userName,
      "user_type": userType,
      "email": email,
      "password": password,
      "department_id": departmentId
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingManager( user_id:$userId,user_name: $userName,user_type:$userType,email:$email ,password:$password,department_id:$departmentId)';
}
