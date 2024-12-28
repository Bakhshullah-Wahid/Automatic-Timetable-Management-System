import 'package:attms/services/subject/fetch_subject.dart';
import 'package:attms/wholeData/subject/update_subject.dart';
import 'package:attms/widget/coordinator/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/dashboard_provider.dart';
import '../../../provider/provider_dashboard.dart';
import '../../../responsive.dart';
import '../../../route/navigations.dart';
import '../../../utils/containor.dart';
import '../../../utils/data/fetching_data.dart';
import '../../../widget/dialoge_box.dart';
import '../../../widget/manager/manager_drawer.dart';
import '../../../widget/title_container.dart';

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

  final FetchingDataCall fetchingDataCall = FetchingDataCall();
  @override
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
          late bool isAdminPages = ref.watch(isAdmin);
          List formatesSubject = [];
          var formattedDepartments = fetchingDataCall.department(ref);
          var formattedTeacher = fetchingDataCall.teacher(ref);
          var formattedSubject = fetchingDataCall.subject(ref);
          bool switchCheck = ref.watch(isAdmin);

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
          final bool mobileCheck = ref.watch(mobileDrawer);
          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
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
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                      itemBuilder:
                                          (context, dynamic element) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TheContainer(
                                                  width: Responsive.isMobile(
                                                          context)
                                                      ? mediaquery.width * 0.57
                                                      : mediaquery.width * 0.7,
                                                  child: ListTile(
                                                      title: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment: switchCheck
                                                                  ? MainAxisAlignment
                                                                      .start
                                                                  : MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: !Responsive.isMobile(
                                                                              context)
                                                                          ? null
                                                                          : MediaQuery.of(context).size.width *
                                                                              0.6,
                                                                      child:
                                                                          Text(
                                                                        element['subject_name'] ??
                                                                            'No Name',
                                                                      ),
                                                                    ),
                                                                    switchCheck
                                                                        ? SizedBox
                                                                            .shrink()
                                                                        : Text(
                                                                            element['teacher_name'] == null
                                                                                ? ' (assign a teacher)'
                                                                                : '',
                                                                            style:
                                                                                TextStyle(color: Colors.red, fontSize: 12),
                                                                          )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            switchCheck
                                                                ? 'Credit Hours (${element['theory']}+${element['lab']})'
                                                                : '(${element['theory']}+${element['lab']})',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          !switchCheck
                                                              ? Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await dialogeOpened(
                                                                                formattedTeacher,
                                                                                departmentShared,
                                                                                element['teacher_name'],
                                                                                courseModule: element['course_module'],
                                                                                departmentId: element['department_id'],
                                                                                lab: element['lab'],
                                                                                semester: element['semester'],
                                                                                subjectId: element['subject_id'],
                                                                                subjectName: element['subject_name'],
                                                                                theory: element['theory']);
                                                                          },
                                                                          child: Text(element['teacher_name'] == null
                                                                              ? 'Assign Teacher'
                                                                              : '${element['teacher_name']}')),
                                                                )
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          context
                                                                              .go(
                                                                            Routes.addSubject,
                                                                            extra: UpdateSubject(
                                                                                semester: element['semester'],
                                                                                subjectId: element['subject_id'],
                                                                                subjectName: element['subject_name'],
                                                                                courseModule: element['course_module'],
                                                                                teacher: element['teacher_id'],
                                                                                lab: element['lab'],
                                                                                theory: element['theory'],
                                                                                teacherList: formattedTeacher,
                                                                                department: element['department_id'],
                                                                                departmentIdList: formattedDepartments),
                                                                          );
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons
                                                                                .edit,
                                                                            color:
                                                                                Colors.black)),
                                                                    IconButton(
                                                                      onPressed:
                                                                          () async {
                                                                        DialogeBoxOpen
                                                                            deletes =
                                                                            DialogeBoxOpen();
                                                                        bool isDelete = await deletes.deleteBox(
                                                                            element['subject_name'],
                                                                            context);
                                                                        if (isDelete) {
                                                                          final SubjectService
                                                                              subjectService =
                                                                              SubjectService();
                                                                          await subjectService
                                                                              .deleteSubject(element['subject_id']);
                                                                        }

                                                                        // Remove the task from the list
                                                                      },
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                        ],
                                                      )),
                                                ),
                                              ))))
                    ],
                  ),
                  mobileCheck
                      ? isAdminPages
                          ? ManagerDrawerBox()
                          : DrawerBox()
                      : SizedBox.shrink(),
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
