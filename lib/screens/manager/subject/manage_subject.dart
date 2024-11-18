import 'package:attms/provider/teacher_provider.dart';
import 'package:attms/services/subject/fetch_subject.dart';
import 'package:attms/wholeData/subject/update_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../provider/department_provider.dart';
import '../../../provider/subject_provider.dart';
import '../../../route/navigations.dart';
import '../../../widget/title_container.dart';

class SubjectView extends ConsumerWidget {
  const SubjectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(departmentProvider.notifier).retrieveDepartments();
    ref.read(subjectProvider.notifier).retrieveSubject();
    ref.read(teacherProvider.notifier).retrieveTeacher();
    final teacher = ref.watch(teacherProvider);
    final department = ref.watch(departmentProvider);
    final subject = ref.watch(subjectProvider);
    // // Convert departments to a list of maps
    List<Map<String, dynamic>> formattedDepartments = department.map((dept) {
      return {
        'department_name': dept.departmentName,
        'department_id': dept.departmentId,
      };
    }).toList();
    List<Map<String, dynamic>> formattedTeacher = teacher.map((dept) {
      return {
        'teacher_id': dept.teacherId,
        'department_id': dept.departmentId,
        'teacher_name': dept.teacherName,
        'email': dept.email
      };
    }).toList();
    List<Map<String, dynamic>> formattedSubject = subject.map((dept) {
      return {
        'subject_id': dept.subjectId,
        'semester':dept.semester,
        'department_id': dept.departmentId,
        'subject_name': dept.subjectName,
        'theory': dept.theory,
        'lab': dept.lab,
        'course_module': dept.courseModule,
        'teacher_id': dept.teacherId
      };
    }).toList();

    for (var i in formattedDepartments) {
      for (var j in formattedSubject) {
        if (i['department_id'] == j['department_id']) {
          j['department_name'] = i['department_name'];
        }
      }
    }

    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const TitleContainer(
            description:
                "Subject registered for each Department are listed below",
            pageTitle: 'Manage Subjects',
            buttonName: 'Add New Subject',
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1))),
                      child: formattedSubject.isEmpty
                          ? Center(
                              child: Text(
                              'No Subject Found',
                              style: Theme.of(context).textTheme.bodySmall,
                            ))
                          : GroupedListView(
                              elements: formattedSubject,
                              groupBy: (element) =>
                                  element['department_name'] ?? '',
                              order: GroupedListOrder.ASC,
                              groupSeparatorBuilder: (String groupByValue) =>
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      groupByValue,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                              itemBuilder: (context, dynamic element) =>
                                  ListTile(
                                    title: Row(
                                      children: [
                                        SizedBox(
                                          width: mediaquery.width * 0.7,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.1))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                element['subject_name'] ??
                                                    'No Name',
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context.go(
                                                Routes.addSubject,
                                                extra: UpdateSubject(
                                                  semester: element['semester'],
                                                    subjectId:
                                                        element['subject_id'],
                                                    subjectName:
                                                        element['subject_name'],
                                                    courseModule: element[
                                                        'course_module'],
                                                    teacher:
                                                        element['teacher_id'],
                                                    lab: element['lab'],
                                                    theory: element['theory'],
                                                    teacherList:
                                                        formattedTeacher,
                                                    department: element[
                                                        'department_id'],
                                                    departmentIdList:
                                                        formattedDepartments),
                                              );
                                            },
                                            icon: const Icon(Icons.edit,
                                                color: Colors.black)),
                                        IconButton(
                                          onPressed: () async {
                                            final SubjectService
                                                subjectService =
                                                SubjectService();
                                            await subjectService.deleteSubject(
                                                element['subject_id']);

                                            // Remove the task from the list
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )))))
        ],
      ),
    ));
  }
}
