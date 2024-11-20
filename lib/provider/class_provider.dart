import 'dart:async';
import 'dart:convert';

import 'package:attms/services/class/fetch_class_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// StateNotifier to manage department fetching state
class ClassNotifier extends StateNotifier<List<FetchingClass>> {
  ClassNotifier() : super([]);

  Future<void> retrieveClass() async {
    try {
      ClassService urlFetch = ClassService();
      final response = await http.get(Uri.parse('${urlFetch.baseUrl}classs/'));
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);

        // Parse and store department data as FetchingClass objects
        state = responseBody
            .map((noteMap) => FetchingClass.fromMap(noteMap))
            .toList();
        // Convert the state to a list of maps (dictionaries)
        // List<Map<String, dynamic>> classLists =
        //     state.map((dept) => dept.toMap()).toList();

        // Print just the list of dictionaries
      } else {
        // print(
        //     'Failed to load departments with status code: ${response.statusCode}');
      }
    } on TimeoutException {
      // print('Request timed out. Please check your network connection.');
    } catch (e) {
      // print('Error occurred: $e');
    }
  }
}

// Provider to access ClassNotifier
final classProvider =
    StateNotifierProvider<ClassNotifier, List<FetchingClass>>((ref) {
  return ClassNotifier();
});

// FetchingClass class definition
class FetchingClass {
  int classId;
  String className;
  String classType;
  int departmentId;

  FetchingClass(
      {required this.classId,
      required this.className,
      required this.classType,
      required this.departmentId});

  factory FetchingClass.fromMap(Map<String, dynamic> map) {
    return FetchingClass(
      classId: map['class_id'] ?? '',
      className: map['class_name'] ?? '',
      classType: map['class_type'] ?? '',
      departmentId: map['department_id'] ?? 0,
    );
  }

  // Convert instance to a Map (useful for JSON)
  Map<String, dynamic> toMap() {
    return {
      'class_id': classId,
      'class_name': className,
      'class_type': classType,
      'department_id': departmentId,
    };
  }

  // Override toString for readable output
  @override
  String toString() =>
      'FetchingClass(class_name: $className,class_id:$classId ,class_type:$classType, department_id: $departmentId)';
}
