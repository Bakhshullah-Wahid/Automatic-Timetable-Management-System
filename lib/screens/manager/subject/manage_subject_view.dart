import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/subject_provider.dart';
import '../../../widget/title_container.dart';

class ManageSubjectView extends ConsumerWidget {
  const ManageSubjectView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(subjectProvider.notifier).retrieveSubjects();
    final subjects = ref.watch(subjectProvider);
    // Convert subjects to a list of maps
    List<Map<String, dynamic>> formattedSubjects = subjects.map((sub) {
      return {
        'subject_name': sub.subjectName,
        'subject_id': sub.subjectId,
        'department': sub.department,
        'course_code': sub.courseCode,
        'theory': sub.theory,
        'lab': sub.lab,
        'assigned_teacher': sub.assignedTeacher,
        'assigned_teacher_id': sub.assignedTeacherId,
      };
    }).toList();
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const TitleContainer(
            description: "Subject registered are listed below",
            pageTitle: 'Manage Subject',
            buttonName: 'Add New Subject',
          ),
          formattedSubjects.isEmpty
              ? Center(
                  child: Text(
                  'No Data Found',
                  style: Theme.of(context).textTheme.bodySmall,
                ))
              : Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.1))),
                          child: ListView.builder(
                              itemCount: formattedSubjects.length,
                              itemBuilder: (context, index) => ListTile(
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
                                                  formattedSubjects[index]
                                                      ['subject_name']),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              // context.go(
                                              //   Routes.addDepartment,
                                              //   extra: UpdateDepartment(
                                              //       subjectName:
                                              //           subjects[index]
                                              //               .subjectName,
                                              //       subjectId:
                                              //           subjects[index]
                                              //               .subjectId),
                                              // );
                                            },
                                            icon: const Icon(Icons.edit,
                                                color: Colors.black)),
                                        IconButton(
                                          onPressed: () async {
                                            // final DepartmentService
                                            //     taskService =
                                            //     DepartmentService();
                                            // await taskService.deleteTask(
                                            //     subjects[index]
                                            //         .subjectId);

                                            // subjects.removeAt(
                                            //     index); // Remove the task from the list

//                                   },
//                                 ),
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
