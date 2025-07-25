import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/class_provider.dart';
import '../../provider/department_provider.dart';
import '../../provider/manager_provider.dart'; 
import '../../provider/subject_provider.dart';
import '../../provider/teacher_provider.dart';
import '../../provider/timetable_provider.dart';

class FetchingDataCall {
  teacher(WidgetRef ref) {
    final teacherNotifier = ref.read(teacherProvider.notifier);
    final container = ProviderContainer();
    teacherNotifier.retrieveTeacher(container);
    final teachersss = ref.watch(teacherProvider);
    List<Map<String, dynamic>> formattedTeacher = teachersss.map((dept) {
      return {
        'teacher_id': dept.teacherId,
        'department_id': dept.departmentId,
        'teacher_name': dept.teacherName,
        'email': dept.email,
        'requested_by': dept.requestedBy,
        'given_to': dept.givenTo
      };
    }).toList();
    return formattedTeacher;
  }

  subject(WidgetRef ref) {
    final subjectNotifier = ref.read(subjectProvider.notifier);
    final container = ProviderContainer();
    subjectNotifier.retrieveSubject(container);
    final subject = ref.watch(subjectProvider);
    // // Convert departments to a list of maps

    List<Map<String, dynamic>> formattedSubject = subject.map((dept) {
      return {
        'subject_id': dept.subjectId,
        'semester': dept.semester,
        'department_id': dept.departmentId,
        'subject_name': dept.subjectName,
        'theory': dept.theory,
        'lab': dept.lab,
        'course_module': dept.courseModule,
        'teacher_id': dept.teacherId
      };
    }).toList();
    return formattedSubject;
  }

  manager(WidgetRef ref, departmentId) {
       final managerNotifier = ref.read(managerProvider.notifier);
    final container = ProviderContainer();
    managerNotifier.retrieveManager(departmentId,container);
    final userss = ref.watch(managerProvider);
    List<Map<String, dynamic>> formattedManager = userss.map((dept) {
      return {
        "user_id": dept.userId,
        "user_name": dept.userName,
        "user_type": dept.userType,
        "email": dept.email,
        "password": dept.password,
        "department_id": dept.departmentId
      };
    }).toList();
    return formattedManager;
  }

  department(WidgetRef ref) {
       final departmentNotifier = ref.read(departmentProvider.notifier);
    final container = ProviderContainer();
    departmentNotifier.retrieveDepartments(container);
    final departments = ref.watch(departmentProvider);
    // Convert departments to a list of maps
    List<Map<String, dynamic>> formattedDepartments = departments.map((dept) {
      return {
        'department_name': dept.departmentName,
        'department_id': dept.departmentId,
      };
    }).toList();
    return formattedDepartments;
  }

  classs(WidgetRef ref) {
    final classNotifier = ref.read(classProvider.notifier);
    final container = ProviderContainer();
    classNotifier.retrieveClass(container);
    final classs = ref.watch(classProvider);
    List<Map<String, dynamic>> formattedClass = classs.map((dept) {
      return {
        'class_id': dept.classId,
        'department_id': dept.departmentId,
        'class_name': dept.className,
        'class_type': dept.classType,
        'requested_by': dept.requestedBy,
        'given_to': dept.givenTo
      };
    }).toList();
    return formattedClass;
  }

  timetables(WidgetRef ref, departmentId) {
       final timetableNotifier = ref.read(timetableProvider.notifier);
    final container = ProviderContainer();
    timetableNotifier.retrieveTimetable(departmentId , container);
    final timetable = ref.watch(timetableProvider);
    List<Map<String, dynamic>> formattedTimetable = timetable.map((dept) {
      return {
        'subject_id': dept.subjectId,
        'teacher_id': dept.teacherId,
        'slot': dept.slot,
        'semester': dept.semester,
        'department_id': dept.departmentId,
        'day_of_week': dept.dayOfWeek,
        'class_id': dept.classId,
        'teacher_department': dept.teacherDepartmentName,
        'class_department': dept.classDepartmentName
      };
    }).toList();
    return formattedTimetable;
  }
 // This returns the list of free slots as maps
}
