// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/coordinator/fetch_user_data.dart';
import '../services/teacher/fetch_teacher.dart';

// StateNotifier to manage department fetching state
class TeacherNotifier extends StateNotifier<List<FetchingTeacher>> {
  TeacherNotifier() : super([]);

  Future<void> retrieveTeacher() async {
    try {
      TeacherService urlFetch = TeacherService();
      final response = await http.get(Uri.parse('${urlFetch.baseUrl}teachers/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingTeacher.fromMap(noteMap))
            .toList();

        // Convert the state to a list of maps (dictionaries)
        List<Map<String, dynamic>> teacherList =
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

// Provider to access TeacherNotifier
final teacherProvider =
    StateNotifierProvider<TeacherNotifier, List<FetchingTeacher>>((ref) {
  return TeacherNotifier();
});
 
// FetchingTeacher class definition
class FetchingTeacher {
  final int teacherId;
  final String teacherName;
 
  final String email;
  
  final int departmentId;

  FetchingTeacher({
    required this.teacherId,
    required this.email,
    required this.teacherName,

    required this.departmentId,
  });

  factory FetchingTeacher.fromMap(Map<String, dynamic> map) {
     
    return FetchingTeacher(
      teacherId: map['teacher_id'] ?? 0,
      email: map['email'] ?? '',
      teacherName: map['teacher_name'] ?? '',
      departmentId: map['department_id'] ?? 0,
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    
    return {
     "teacher_id": teacherId,
        "teacher_name": teacherName,
        "email": email,
        "department_id": departmentId
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingTeacher( teacher_id:$teacherId,teacher_name: $teacherName,email:$email ,department_id:$departmentId)';
}
