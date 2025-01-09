// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class TeacherNotifier extends StateNotifier<List<FetchingTeacher>> {
  TeacherNotifier() : super([]);

  Future<void> retrieveTeacher() async {
    API url = API();
    try {
      final response = await http.get(Uri.parse('${url.baseUrl}teachers/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingTeacher.fromMap(noteMap))
            .toList();
      } else {
        // Handle non-200 status codes
        // print('Failed to load teachers: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving teachers: $e');
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
  String? requestedBy;
  String? givenTo;

  FetchingTeacher(
      {required this.teacherId,
      required this.email,
      required this.teacherName,
      required this.departmentId,
      required this.givenTo,
      required this.requestedBy});
  factory FetchingTeacher.fromMap(Map<String, dynamic> map) {
    return FetchingTeacher(
      teacherId: map['teacher_id'] ?? 0,
      email: map['email'] ?? '',
      teacherName: map['teacher_name'] ?? '',
      departmentId: map['department_id'] ?? 0,
      requestedBy: map['requested_by'] ?? '',
      givenTo: map['given_to'] ?? '',
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      "teacher_id": teacherId,
      "teacher_name": teacherName,
      "email": email,
      "department_id": departmentId,
      "requested_by": requestedBy,
      "given_to": givenTo
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingTeacher( teacher_id:$teacherId,teacher_name: $teacherName,email:$email ,department_id:$departmentId ,requested_by:$requestedBy,given_to:$givenTo)';
}
