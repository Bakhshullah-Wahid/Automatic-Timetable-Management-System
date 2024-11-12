// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/coordinator/fetch_user_data.dart';

// StateNotifier to manage department fetching state
class ManagerNotifier extends StateNotifier<List<FetchingManager>> {
  ManagerNotifier() : super([]);

  Future<void> retrieveManager() async {
    try {
      ManagerService urlFetch = ManagerService();
      final response = await http.get(Uri.parse('${urlFetch.baseUrl}users/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingManager objects
        state = responseBody
            .map((noteMap) => FetchingManager.fromMap(noteMap))
            .toList();

        // Convert the state to a list of maps (dictionaries)
        List<Map<String, dynamic>> managerList =
            state.map((dept) => dept.toMap()).toList();

        // Print just the list of dictionaries
      } else {
        print(
            'Failed to load departments with status code: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Request timed out. Please check your network connection.');
    } catch (e) {
      print('Error occurred: $e');
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
