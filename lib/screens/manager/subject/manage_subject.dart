import 'package:attms/provider/teacher_provider.dart';
import 'package:attms/services/subject/fetch_subject.dart';
import 'package:attms/wholeData/subject/update_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/department_provider.dart';
import '../../../provider/provider_dashboard.dart';
import '../../../provider/subject_provider.dart';
import '../../../route/navigations.dart';
import '../../../widget/dialoge_box.dart';
import '../../../widget/title_container.dart';

// class SubjectView extends ConsumerWidget {
//   const SubjectView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     bool switchCheck = ref.watch(isAdmin);
//     ref.read(departmentProvider.notifier).retrieveDepartments();
//     ref.read(subjectProvider.notifier).retrieveSubject();
//     ref.read(teacherProvider.notifier).retrieveTeacher();
//     final teacher = ref.watch(teacherProvider);
//     final department = ref.watch(departmentProvider);
//     final subject = ref.watch(subjectProvider);
//     // // Convert departments to a list of maps
//     List<Map<String, dynamic>> formattedDepartments = department.map((dept) {
//       return {
//         'department_name': dept.departmentName,
//         'department_id': dept.departmentId,
//       };
//     }).toList();
//     List<Map<String, dynamic>> formattedTeacher = teacher.map((dept) {
//       return {
//         'teacher_id': dept.teacherId,
//         'department_id': dept.departmentId,
//         'teacher_name': dept.teacherName,
//         'email': dept.email
//       };
//     }).toList();
//     List<Map<String, dynamic>> formattedSubject = subject.map((dept) {
//       return {
//         'subject_id': dept.subjectId,
//         'semester': dept.semester,
//         'department_id': dept.departmentId,
//         'subject_name': dept.subjectName,
//         'theory': dept.theory,
//         'lab': dept.lab,
//         'course_module': dept.courseModule,
//         'teacher_id': dept.teacherId
//       };
//     }).toList();

//     for (var i in formattedDepartments) {
//       for (var j in formattedSubject) {
//         if (i['department_id'] == j['department_id']) {
//           j['department_name'] = i['department_name'];
//         }
//       }
//     }

//     var mediaquery = MediaQuery.of(context).size;
//     return Scaffold(
//         body: Container(
//       color: Colors.white,
//       child: SafeArea(
//         child: Column(
//           children: [
//             TitleContainer(
//               description:
//                   "Subject registered for each Department are listed below",
//               pageTitle: switchCheck ? 'Manage Subjects' : 'Manage subjects',
//               buttonName: switchCheck ? 'Add New Subject' : '',
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Expanded(
//                 child: Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: formattedSubject.isEmpty
//                         ? Center(
//                             child: Text(
//                             'No Subject Found',
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ))
//                         : GroupedListView(
//                             elements:switchCheck? formattedSubject:,
//                             groupBy: (element) =>
//                                 element['department_name'] ?? '',
//                             order: GroupedListOrder.ASC,
//                             groupSeparatorBuilder: (String groupByValue) =>
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 15.0),
//                                         child: Text(
//                                           groupByValue,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .bodySmall,
//                                         ),
//                                       ),
//                                       Divider()
//                                     ],
//                                   ),
//                                 ),
//                             itemBuilder: (context, dynamic element) => ListTile(
//                                   title: Row(
//                                     children: [
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 20.0),
//                                         child: Container(
//                                           width: mediaquery.width * 0.7,
//                                           decoration: BoxDecoration(
//                                             color: Colors
//                                                 .white, // Background color of the container
//                                             borderRadius: BorderRadius.circular(
//                                                 8), // Optional: rounded corners
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black.withOpacity(
//                                                     0.2), // Shadow color with opacity
//                                                 offset: Offset(
//                                                     0, 10), // Shadow only below
//                                                 blurRadius:
//                                                     8, // Controls how blurry the shadow is
//                                                 spreadRadius:
//                                                     0.3, // Spread of the shadow
//                                               ),
//                                             ],
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(
//                                               element['subject_name'] ??
//                                                   'No Name',
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       IconButton(
//                                           onPressed: () {
//                                             context.go(
//                                               Routes.addSubject,
//                                               extra: UpdateSubject(
//                                                   semester: element['semester'],
//                                                   subjectId:
//                                                       element['subject_id'],
//                                                   subjectName:
//                                                       element['subject_name'],
//                                                   courseModule:
//                                                       element['course_module'],
//                                                   teacher:
//                                                       element['teacher_id'],
//                                                   lab: element['lab'],
//                                                   theory: element['theory'],
//                                                   teacherList: formattedTeacher,
//                                                   department:
//                                                       element['department_id'],
//                                                   departmentIdList:
//                                                       formattedDepartments),
//                                             );
//                                           },
//                                           icon: const Icon(Icons.edit,
//                                               color: Colors.black)),
//                                       IconButton(
//                                         onPressed: () async {
//                                           final SubjectService subjectService =
//                                               SubjectService();
//                                           await subjectService.deleteSubject(
//                                               element['subject_id']);

//                                           // Remove the task from the list
//                                         },
//                                         icon: const Icon(Icons.delete,
//                                             color: Colors.black),
//                                       ),
//                                     ],
//                                   ),
//                                 ))))
//           ],
//         ),
//       ),
//     ));
//   }
// }

class SubjectView extends StatefulWidget {
  const SubjectView({super.key});

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  String departmentShared = '';
  void journal() async {
    var prefs2 = await SharedPreferences.getInstance();
    departmentShared = prefs2.getString('department').toString();
  }

  void initState() {
    super.initState();
    journal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          List formatesSubject = [];
          bool switchCheck = ref.watch(isAdmin);
          ref.read(departmentProvider.notifier).retrieveDepartments();
          ref.read(subjectProvider.notifier).retrieveSubject();
          ref.read(teacherProvider.notifier).retrieveTeacher();
          final teacher = ref.watch(teacherProvider);
          final department = ref.watch(departmentProvider);
          final subject = ref.watch(subjectProvider);
          // // Convert departments to a list of maps
          List<Map<String, dynamic>> formattedDepartments =
              department.map((dept) {
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
              'semester': dept.semester,
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
          for (var i in formattedDepartments) {
            for (var j in formattedTeacher) {
              if (i['department_id'] == j['department_id']) {
                j['department_name'] = i['department_name'];
              }
            }
          }
          for (var i in formattedTeacher) {
            for (var j in formattedSubject) {
              if (i['teacher_id'] == j['teacher_id']) {
                j['teacher_name'] = i['teacher_name'];
              }
            }
          }

          for (var formatSubject in formattedSubject) {
            if (formatSubject['department_name'] == departmentShared) {
              formatesSubject.add(formatSubject);
            }
          }
          var mediaquery = MediaQuery.of(context).size;
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  TitleContainer(
                    description:
                        "Subject registered for each Department are listed below",
                    pageTitle:
                        switchCheck ? 'Manage Subjects' : 'Manage subjects',
                    buttonName: switchCheck ? 'Add New Subject' : '',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: formattedSubject.isEmpty
                              ? Center(
                                  child: Text(
                                  'No Subject Found',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ))
                              : GroupedListView(
                                  elements: switchCheck
                                      ? formattedSubject
                                      : formatesSubject,
                                  groupBy: (element) => switchCheck
                                      ? element['department_name'] ?? ''
                                      : element['semester'] ?? '',
                                  order: GroupedListOrder.ASC,
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child: Text(
                                                    groupByValue,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ),
                                                Divider()
                                              ],
                                            ),
                                          ),
                                  itemBuilder: (context, dynamic element) =>
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Container(
                                                width: mediaquery.width * 0.7,
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .white, // Background color of the container
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8), // Optional: rounded corners
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.2), // Shadow color with opacity
                                                      offset: Offset(0,
                                                          1), // Shadow only below
                                                      blurRadius:
                                                          3, // Controls how blurry the shadow is
                                                      spreadRadius:
                                                          0.4, // Spread of the shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        switchCheck
                                                            ? MainAxisAlignment
                                                                .start
                                                            : MainAxisAlignment
                                                                .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            element['subject_name'] ??
                                                                'No Name',
                                                          ),
                                                          switchCheck
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Text(
                                                                  element['teacher_name'] ==
                                                                          null
                                                                      ? ' (assign a teacher)'
                                                                      : '',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          12),
                                                                )
                                                        ],
                                                      ),
                                                      !switchCheck
                                                          ? ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                await dialogeOpened(
                                                                    formattedTeacher,
                                                                    departmentShared,
                                                                    element[
                                                                        'teacher_name'],
                                                                    courseModule:
                                                                        element[
                                                                            'course_module'],
                                                                    departmentId:
                                                                        element[
                                                                            'department_id'],
                                                                    lab: element[
                                                                        'lab'],
                                                                    semester:
                                                                        element[
                                                                            'semester'],
                                                                    subjectId:
                                                                        element[
                                                                            'subject_id'],
                                                                    subjectName:
                                                                        element[
                                                                            'subject_name'],
                                                                    theory: element[
                                                                        'theory']);
                                                              },
                                                              child: Text(element[
                                                                          'teacher_name'] ==
                                                                      null
                                                                  ? 'Assign Teacher'
                                                                  : '${element['teacher_name']}'))
                                                          : SizedBox.shrink()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            switchCheck
                                                ? IconButton(
                                                    onPressed: () {
                                                      context.go(
                                                        Routes.addSubject,
                                                        extra: UpdateSubject(
                                                            semester: element[
                                                                'semester'],
                                                            subjectId: element[
                                                                'subject_id'],
                                                            subjectName: element[
                                                                'subject_name'],
                                                            courseModule: element[
                                                                'course_module'],
                                                            teacher: element[
                                                                'teacher_id'],
                                                            lab: element['lab'],
                                                            theory: element[
                                                                'theory'],
                                                            teacherList:
                                                                formattedTeacher,
                                                            department: element[
                                                                'department_id'],
                                                            departmentIdList:
                                                                formattedDepartments),
                                                      );
                                                    },
                                                    icon: const Icon(Icons.edit,
                                                        color: Colors.black))
                                                : SizedBox.shrink(),
                                            switchCheck
                                                ? IconButton(
                                                    onPressed: () async {
                                                      DialogeBoxOpen deletes =
                                                          DialogeBoxOpen();
                                                      bool isDelete =
                                                          await deletes.deleteBox(
                                                              element[
                                                                  'subject_name'],
                                                              context);
                                                      if (isDelete) {
                                                        final SubjectService
                                                            subjectService =
                                                            SubjectService();
                                                        await subjectService
                                                            .deleteSubject(element[
                                                                'subject_id']);
                                                      }

                                                      // Remove the task from the list
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.black),
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ))))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  dialogeOpened(teacherAccept, departmentShared, selectedSem,
      {semester,
      subjectId,
      subjectName,
      courseModule,
      departmentId,
      lab,
      theory}) async {
    List jambo = [];
    for (var k in teacherAccept) {
      if (k['department_name'] == departmentShared) {
        jambo.add(k);
      }
    }
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Select Teacher'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: jambo.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 100,
                          height: 50,
                          child: Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor:
                                    const Color.fromARGB(255, 236, 156, 92),
                                value:
                                    selectedSem == jambo[index]['teacher_name'],
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      SubjectService subjectUpdate =
                                          SubjectService();
                                      subjectUpdate.updateSubject(
                                          semester,
                                          subjectId,
                                          subjectName,
                                          courseModule,
                                          departmentId,
                                          jambo[index]['teacher_id'],
                                          lab,
                                          theory);
                                      Navigator.pop(context);
                                    } else {
                                      selectedSem = null;
                                    }
                                  });
                                },
                              ),
                              Text(jambo[index]['teacher_name']),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
