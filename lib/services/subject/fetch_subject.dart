import 'dart:convert';
import 'package:http/http.dart' as http;

// departmentServicefromDjango

class SubjectService {
  final String baseUrl =
      'http://127.0.0.1:8000/'; // Change to your Django server URL
  Future<void> addSubject(String subjectName) async {
    final response = await http.post(
      Uri.parse('${baseUrl}subjects/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'subject_name': subjectName,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add subject');
    }
  }

  Future<void> updateSubject(int? id, String subjectName) async {
    final response = await http.put(
      Uri.parse('${baseUrl}subjects/update/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'subject_name': subjectName,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, navigate back or show a success message
    } else {
      // If the server did not return an OK response, throw an exception
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteSubject(int id) async {
    final response =
        await http.delete(Uri.parse('${baseUrl}subjects/delete/$id/'));
    if (response.statusCode == 204) {
      print('Subject deleted successfully');
    } else {
      print('Failed to delete task: ${response.statusCode}');
    }
  }
}

class SubjectFetching {
  String subjectName;
  int subjectId;
  String department;
  String courseCode;
  int theory;
  int lab;
  String assignedTeacher;
  int assignedTeacherId;

  SubjectFetching(
      {required this.subjectName,
      required this.subjectId,
      required this.department,
      required this.courseCode,
      required this.theory,
      required this.lab,
      required this.assignedTeacher,
      required this.assignedTeacherId});

  factory SubjectFetching.fromMap(Map<String, dynamic> map) {
    return SubjectFetching(
      subjectName: map['subject_name'],
      subjectId: map['subject_id'],
      department: map['department'],
      courseCode: map['course_code'],
      theory: map['theory'],
      lab: map['lab'],
      assignedTeacher: map['assigned_teacher'],
      assignedTeacherId: map['assigned_teacher_id'],
    );
  }

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

  String toJson() => json.encode(toMap());
}
