import 'dart:async';
import 'dart:convert';

import 'package:attms/widget/base_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// StateNotifier to manage department fetching state
class TimetableNotifier extends StateNotifier<List<FetchingTimetable>> {
  TimetableNotifier() : super([]);

  Future<void> retrieveTimetable(
      int departmentId, ProviderContainer container) async {
    API api = API();
    try {
      final response =
          await http.get(Uri.parse('${api.baseUrl}scheduler/$departmentId'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingTeacher objects
        state = responseBody
            .map((noteMap) => FetchingTimetable.fromMap(noteMap))
            .toList();
        container.dispose();
      } else {
        // Handle non-200 status codes
        // print('Failed to load timetable: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error retrieving timetable: $e');
    }
  }
}

// Provider to access TimetableNotifier
final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<FetchingTimetable>>((ref) {
  return TimetableNotifier();
});

// FetchingTimetable class definition
class FetchingTimetable {
  int classId;
  int subjectId;
  int teacherId;
  String slot;
  String semester;
  int departmentId;
  String dayOfWeek;
  String teacherDepartmentName;
  String classDepartmentName;

  FetchingTimetable(
      {required this.classId,
      required this.classDepartmentName,
      required this.teacherDepartmentName,
      required this.subjectId,
      required this.teacherId,
      required this.slot,
      required this.departmentId,
      required this.semester,
      required this.dayOfWeek});

  factory FetchingTimetable.fromMap(Map<String, dynamic> map) {
    return FetchingTimetable(
        classId: map['class_id'] ?? 0,
        subjectId: map['subject_id'] ?? 0,
        teacherId: map['teacher_id'] ?? 0,
        slot: map['slot'] ?? '',
        semester: map['semester'] ?? '',
        departmentId: map['department_id'] ?? 0,
        dayOfWeek: map['day_of_week'] ?? '',
        classDepartmentName: map['class_department'],
        teacherDepartmentName: map['teacher_department']);
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'teacher_department': teacherDepartmentName,
      'class_department': classDepartmentName,
      'class_id': classId,
      'subject_id': subjectId,
      'teacher_id': teacherId,
      'slot': slot,
      'semester': semester,
      'department_id': departmentId,
      'day_of_week': dayOfWeek,
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingTimetable(class_id: $classId,subject_id:$subjectId ,teacher_id:$teacherId, slot: $slot ,semester:$semester ,department_id:$departmentId ,day_of_week:$dayOfWeek , class_department:$classDepartmentName , teacher_department:$teacherDepartmentName)';
}
