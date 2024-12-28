import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../widget/base_api.dart';

// departmentServicefromDjango

class ScheduleService {
  API api = API();
  // Change to your Django server URL
  Future<void> addTimetable(int classId, int subjectId, int teacherId,
      String day, String slot, String semester, int departmentId , String teacherDepartmentName , String classDepartmentName) async {
    await http.post(
      Uri.parse('${api.baseUrl}scheduler/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'class_id': classId,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'day_of_week': day,
        'slot': slot,
        'semester': semester,
        'department_id': departmentId,
        'teacher_department':teacherDepartmentName,
        'class_department':classDepartmentName
      }),
    );
  }

  Future<void> deleteTimetable(int id) async {
    final response = await http.delete(
      Uri.parse('${api.baseUrl}scheduler/$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      // Success
    } else {
      throw Exception('Failed to delete timetable: ${response.body}');
    }
  }
}
