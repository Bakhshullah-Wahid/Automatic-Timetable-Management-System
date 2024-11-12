import 'package:attms/services/teacher/fetch_teacher.dart';
import 'package:attms/wholeData/teacher/update_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../provider/department_provider.dart';
import '../../../provider/teacher_provider.dart';
import '../../../route/navigations.dart'; 
import '../../../widget/title_container.dart';

class TeacherView extends ConsumerWidget {
  const TeacherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(departmentProvider.notifier).retrieveDepartments();
    ref.read(teacherProvider.notifier).retrieveTeacher();
    final department = ref.watch(departmentProvider);
    final teachersss = ref.watch(teacherProvider);
    // // Convert departments to a list of maps
    List<Map<String, dynamic>> formattedDepartments = department.map((dept) {
      return {
        'department_name': dept.departmentName,
        'department_id': dept.departmentId,
      };
    }).toList();
    List<Map<String, dynamic>> formattedTeacher = teachersss.map((dept) {
      return {
        'teacher_id': dept.teacherId,
        'department_id': dept.departmentId,
        'teacher_name': dept.teacherName,
        'email': dept.email
      };
    }).toList();

    for (var i in formattedDepartments) {
      for (var j in formattedTeacher) {
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
                "Teacher registered for each Department are listed below",
            pageTitle: 'Manage Teacher',
            buttonName: 'Add New Teacher',
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
                      child: formattedTeacher.isEmpty
                          ? Center(
                              child: Text(
                              'No Class Found',
                              style: Theme.of(context).textTheme.bodySmall,
                            ))
                          : GroupedListView(
                              elements: formattedTeacher,
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
                                                element['teacher_name'] ??
                                                    'No Name',
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context.go(
                                                Routes.addTeacher,
                                                extra: UpdateTeacher(
                                                    teacherId:
                                                        element['teacher_id'],
                                                    teacherName:
                                                        element['teacher_name'],
                                                    email:
                                                        element['email'],
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
                                            final TeacherService teachersService =
                                                TeacherService();
                                            await teachersService.deleteClass(
                                                element['teacher_id']);

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
