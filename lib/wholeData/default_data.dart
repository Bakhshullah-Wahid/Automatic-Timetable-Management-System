import 'dart:convert';
import 'package:http/http.dart' as http;

class Schedule {
  final String subjectName;
  final String teacherName;
  final String className;
  final String day;
  final String slot;
  final String department;
  final String teacherDepartment;
  final String classDepartment;

  Schedule({required this.classDepartment,required this.teacherDepartment,
    required this.subjectName,
    required this.teacherName,
    required this.className,
    required this.day,
    required this.slot,
    required this.department,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject_name': subjectName,
      'teacher_name': teacherName,
      'class_name': className,
      'day': day,
      'slot': slot,
      'department': department,
    };
  }
}

Future<void> addSchedulesToServer(List<Map<String, dynamic>> schedules) async {
  final url = Uri.parse('http://172.0.0.1:8000/add_schedules/');
  await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(schedules),
  );
}
