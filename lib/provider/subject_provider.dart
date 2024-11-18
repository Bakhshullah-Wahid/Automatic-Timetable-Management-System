// department_provider.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../services/subject/fetch_subject.dart';

// StateNotifier to manage department fetching state
class SubjectNotifier extends StateNotifier<List<FetchingSubject>> {
  SubjectNotifier() : super([]);

  Future<void> retrieveSubjects() async {
    try {
      SubjectService urlFetch = SubjectService();
      final response =
          await http.get(Uri.parse('${urlFetch.baseUrl}subjects/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingSubject objects
        state = responseBody
            .map((noteMap) => FetchingSubject.fromMap(noteMap))
            .toList();

        // Convert the state to a list of maps (dictionaries)
        List<Map<String, dynamic>> subjectList =
            state.map((sub) => sub.toMap()).toList();

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

// Provider to access SubjectNotifier
final subjectProvider =
    StateNotifierProvider<SubjectNotifier, List<FetchingSubject>>((ref) {
  return SubjectNotifier();
});

// FetchingSubject class definition
class FetchingSubject {
  final String subjectName;
  final int subjectId;
  final String department;
  final String courseCode;
  final int theory;
  final int lab;
  final String assignedTeacher;
  final int assignedTeacherId;

  FetchingSubject(
      {required this.subjectName,
      required this.subjectId,
      required this.department,
      required this.courseCode,
      required this.theory,
      required this.lab,
      required this.assignedTeacher,
      required this.assignedTeacherId});

  factory FetchingSubject.fromMap(Map<String, dynamic> map) {
    return FetchingSubject(
      subjectName: map['subject_name'] ?? '',
      subjectId: map['subject_id'] ?? 0,
      department: map['department'] ?? '',
      courseCode: map['course_code'] ?? '',
      theory: map['theory'] ?? 0,
      lab: map['lab'] ?? 0,
      assignedTeacher: map['assigned_teacher'] ?? '',
      assignedTeacherId: map['assigned_teacher_id'] ?? '',
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'subject_name': subjectName,
      'subject_id': subjectId,
      'department': department,
      'course_code': courseCode,
      'theory': theory,
      'lab': lab,
      'assigned_teacher': assignedTeacher,
      'assigned_teacher_id': assignedTeacherId,
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingSubject(subject_name: $subjectName,subject_id: $subjectId,department :$department,course_code:  $courseCode,theory :$theory,lab:$lab,assigned_teacher: $assignedTeacher,assigned_teacher_id :$assignedTeacherId, )';
}
