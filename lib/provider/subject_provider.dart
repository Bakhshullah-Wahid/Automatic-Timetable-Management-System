// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../widget/base_api.dart';

// StateNotifier to manage department fetching state
class SubjectNotifier extends StateNotifier<List<FetchingSubject>> {
  SubjectNotifier() : super([]);

  Future<void> retrieveSubject(ProviderContainer container) async {
    API api = API();
    
      try{
      final response =
          await http.get(Uri.parse('${api.baseUrl}subjects/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingSubject.fromMap(noteMap))
            .toList();container.dispose();
      } else {
        // Handle non-200 status codes
        // print('Failed to load subjects: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving subjects: $e');
    }
  }
  
  
}

// Provider to access SubjectNotifier
final subjectProvider =
    StateNotifierProvider<SubjectNotifier, List<FetchingSubject>>((ref) {
  return SubjectNotifier();
});

// FetchingSubject class definition
class FetchingSubject {
  int subjectId;
  String subjectName;
  String semester;
  String courseModule;
  int departmentId;
  int teacherId;
  int theory;
  int lab;

  FetchingSubject(
      {required this.subjectId,
      required this.subjectName,
      required this.semester,
      required this.courseModule,
      required this.departmentId,
      required this.lab,
      required this.teacherId,
      required this.theory});

  factory FetchingSubject.fromMap(Map<String, dynamic> map) {
    return FetchingSubject(
      semester: map['semester']??'',
        subjectId: map['subject_id'] ?? '',
        subjectName: map['subject_name'] ?? '',
        courseModule: map['course_module'] ?? '',
        departmentId: map['department_id'] ?? 0,
        lab: map['lab'] ?? 0,
        theory: map['theory'] ?? 0,
        teacherId: map['teacher_id'] ?? 0);
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'semester':semester,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'course_module': courseModule,
      'department_id': departmentId,
      'lab': lab,
      'theory': theory,
      'teacher_id': teacherId
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingSubject(subject_name: $subjectName,subject_id:$subjectId ,course_module:$courseModule, department_id: $departmentId , teacher_id:$teacherId , lab:$lab , theory:$theory , semester:$semester)';
}
