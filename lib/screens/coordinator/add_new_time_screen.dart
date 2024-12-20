import 'package:attms/provider/add_new_time_provider.dart';
import 'package:attms/utils/date_time.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/class_provider.dart';
import '../../provider/department_provider.dart';
import '../../provider/subject_provider.dart';
import '../../provider/teacher_provider.dart';
import '../../widget/dialoge_box.dart';

class NewTimeTableScreen extends StatefulWidget {
  const NewTimeTableScreen({super.key});

  @override
  State<NewTimeTableScreen> createState() => _NewTimeTableScreenState();
}

class _NewTimeTableScreenState extends State<NewTimeTableScreen> {
  int switchScreen = 0;
  List sems = ['semester 01', 'semester 02'];
  List selectedClass = [];
  List freeClass = [];
  // List subjectData = [];
  List selectedTeachers = [];
  List teacherFreeTime = [];
  List searchedTeacher = [];
  DialogeBoxOpen dialogebox = DialogeBoxOpen();
  String? selectedSem;
  String? selectedDepartment;
  List<Map<String, dynamic>> formattedSubject = [];
  List<Map<String, dynamic>> formattedTeacher = [];
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final position = ref.watch(addNewTimetableProvider);
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
        formattedSubject = subject.map((dept) {
          return {
            'subject_id': dept.subjectId,
            'department_id': dept.departmentId,
            'subject_name': dept.subjectName,
            'theory': dept.theory,
            'lab': dept.lab,
            'course_module': dept.courseModule,
            'teacher_id': dept.teacherId,
            'semester': dept.semester
          };
        }).toList();
        formattedTeacher = teacher.map((dept) {
          return {
            'teacher_id': dept.teacherId,
            'department_id': dept.departmentId,
            'teacher_name': dept.teacherName,
            'email': dept.email
          };
        }).toList();

        for (var i in formattedDepartments) {
          for (var j in formattedSubject) {
            if (i['department_id'] == j['department_id']) {
              j['department_name'] = i['department_name'];
            }
          }
        }
        for (var addTeacher in formattedTeacher) {
          for (var addSubject in formattedSubject) {
            if (addTeacher['teacher_id'] == addSubject['teacher_id']) {
              addSubject['teacher_name'] = addTeacher['teacher_name'];
            }
          }
        }

        return position == 0
            ? _buildSemesterSelection(context)
            : position == 1
                ? _buildClass(context)
                : position == 2
                    ? _buildTeacher(context)
                    : position == 3
                        ? _buildSubject(context)
                        : _buildGenerateTimetable(context);
      },
    );
  }
// add time

  TimeOfDay time = TimeOfDay.now();
  String slot1SelectedStart = "9:30 AM";
  String slot1SelectedEnd = "11:00 AM";
  String slot2SelectedStart = "11:30 AM";
  String slot2SelectedEnd = "1:00 PM";
  String slot3SelectedStart = "1:30 PM";
  String slot3SelectedEnd = "3:00 PM";
// subject
  List filteredDataEven = [];
  List filteredDataOdd = [];
  List teacherSelection = [];
  List otherDepartmentTeacher = [];
  String department = '';
  filteringData() async {
    var prefs2 = await SharedPreferences.getInstance();
    department = prefs2.getString('department').toString();
    for (int i = 0; i < formattedSubject.length; i++) {
      if (formattedSubject[i]['department_name'] == department) {
        if (selectedSem == 'semester 01') {
          if (formattedSubject[i]['semester'] == 'semester 01' ||
              formattedSubject[i]['semester'] == 'semester 03' ||
              formattedSubject[i]['semester'] == 'semester 05' ||
              formattedSubject[i]['semester'] == 'semester 07') {
            filteredDataOdd.add(formattedSubject[i]);
          }
        } else {
          if (selectedSem == 'semester 02') {
            if (formattedSubject[i]['semester'] == 'semester 02' ||
                formattedSubject[i]['semester'] == 'semester 04' ||
                formattedSubject[i]['semester'] == 'semester 06' ||
                formattedSubject[i]['semester'] == 'semester 08') {
              filteredDataEven.add(formattedSubject[i]);
            }
          }
        }
      }
    }
    setState(() {});
  }

  // filteringData() async {
  //   var prefs2 = await SharedPreferences.getInstance();
  //   department = prefs2.getString('department').toString();

  //   for (int i = 0; i < defaultData.wholeSubject.length; i++) {
  //     if (defaultData.wholeSubject[i]['department_name'] == department) {
  //       if (selectedSem == 'semester 01') {
  //         if (defaultData.wholeSubject[i]['semester'] == 'semester 01' ||
  //             defaultData.wholeSubject[i]['semester'] == 'semester 03' ||
  //             defaultData.wholeSubject[i]['semester'] == 'semester 05' ||
  //             defaultData.wholeSubject[i]['semester'] == 'semester 07') {
  //           filteredDataOdd.add(defaultData.wholeSubject[i]);
  //         }
  //       } else {
  //         if (selectedSem == 'semester 02') {
  //           if (defaultData.wholeSubject[i]['semester'] == 'semester 02' ||
  //               defaultData.wholeSubject[i]['semester'] == 'semester 04' ||
  //               defaultData.wholeSubject[i]['semester'] == 'semester 06' ||
  //               defaultData.wholeSubject[i]['semester'] == 'semester 08') {
  //             filteredDataEven.add(defaultData.wholeSubject[i]);
  //           }
  //         }
  //       }
  //     }
  //   }
  //   for (int j = 0; j < defaultData.teacherAndDepartment.length; j++) {
  //     if (defaultData.teacherAndDepartment[j]['department_name'] == department) {
  //       teacherSelection.add(defaultData.teacherAndDepartment[j]);
  //     } else {
  //       otherDepartmentTeacher.add(defaultData.teacherAndDepartment[j]);
  //     }
  //   }
  //   teacherSelection.add({"teacher_name": "Others"});

  //   setState(() {});
  // }

  DateTimeHelper dateTimeHelper = DateTimeHelper();
  Widget _buildSubject(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleContainer(
              pageTitle: 'Subject Selected',
              description:
                  'Select Teacher(visitor/Other department_name Teacher/Your Own department_name for each subject listed below)',
              buttonName: 'Next',
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: selectedSem == null
                    ? Stack(
                        children: [
                          Center(
                            child: Opacity(
                              opacity: 0.2,
                              child: Image.asset(
                                'assets/images/uot.png',
                                scale: 1.15,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Please Select Semester First',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      )
                    : GroupedListView<dynamic, String>(
                        elements: selectedSem == 'semester 01'
                            ? filteredDataOdd
                            : filteredDataEven,
                        groupBy: (element) {
                          return element['semester'];
                        },
                        order: GroupedListOrder.ASC,
                        groupSeparatorBuilder: (String groupByValue) => Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 8, left: 8, right: 8),
                              child: Column(
                                children: [
                                  Text(
                                    groupByValue,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const Divider()
                                ],
                              ),
                            ),
                        itemBuilder: (context, dynamic element) => ListTile(
                              title: Column(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // Background color of the container
                                            borderRadius: BorderRadius.circular(
                                                8), // Optional: rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color with opacity
                                                offset: const Offset(
                                                    0, 1), // Shadow only below
                                                blurRadius:
                                                    3, // Controls how blurry the shadow is
                                                spreadRadius:
                                                    0.4, // Spread of the shadow
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  element['subject_name'],
                                                  // '${element['subject_name']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                ),
                                                selectedTeachers.isNotEmpty
                                                    ? ElevatedButton(
                                                        onPressed: () async {
                                                          List
                                                              selectedTeacher1 =
                                                              await dialogebox.teacherSelection(
                                                                  'Select Teacher',
                                                                  context,
                                                                  selectedTeachers,
                                                                  element[
                                                                      'teacher_name']);

                                                          if (selectedTeacher1[
                                                                      0] !=
                                                                  '' ||
                                                              selectedTeacher1[
                                                                      0] !=
                                                                  null) {
                                                            element['teacher_name'] =
                                                                selectedTeacher1[
                                                                    0];
                                                            element['teacher_id'] =
                                                                selectedTeacher1[
                                                                    1];

                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Text(element[
                                                                        'teacher_name'] ==
                                                                    '' ||
                                                                element['teacher_name'] ==
                                                                    null
                                                            ? 'Select teacher'
                                                            : element[
                                                                'teacher_name']))
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController timetableName = TextEditingController();
// select semester
  Widget _buildSemesterSelection(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleContainer(
            description:
                'Choose Semester, By choosing semester 1 will enable automatic selecting other semester with subjects respectively ',
            pageTitle: 'New Timetable',
            buttonName: 'Next',
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        'assets/images/uot.png',
                        scale: 1,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(
                              8), // Optional: rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with opacity
                              offset: const Offset(0, 1), // Shadow only below
                              blurRadius:
                                  3, // Controls how blurry the shadow is
                              spreadRadius: 0.4, // Spread of the shadow
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name is required';
                              } else {
                                return null;
                              }
                            },
                            controller: timetableName,
                            cursorHeight: 20,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),

                              labelText: 'Timetable Name',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 10),
                              prefixIcon: const Icon(Icons.schedule,
                                  color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: InputBorder.none,
                              //  OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(12.0),
                              // ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                          'Select the Semester(by selecting semester 01, every odd semesters are selected automatically by  Timetable management system',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      Center(
                          child: ElevatedButton(
                              onPressed: () async {
                                selectedSem =
                                    await dialogebox.dialogeBoxOpening(
                                  'Select Semester',
                                  context,
                                  sems,
                                );
                                filteringData();
                                setState(() {});
                              },
                              child: Text(selectedSem == null
                                  ? 'Select Semester'
                                  : '$selectedSem'))),

                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          'Selected start and End time for 1st slot classes',
                          // (Time from 9:00 to 3:30 are accepted and Friday is a special case for the Time Selection)',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '9:30 AM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30),
                          //   child: SizedBox(
                          //       width: 150,
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             slot1SelectedStart =
                          //                 await DateTimeHelper.pickTime(
                          //                     time, context);
                          //             setState(() {});
                          //           },
                          //           child: Text(slot1SelectedStart == ''
                          //               ? 'Enter Time'
                          //               : slot1SelectedStart))),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'To',
                            style: TextStyle(color: Colors.black),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30),
                          //   child: SizedBox(
                          //       width: 150,
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             slot1SelectedEnd =
                          //                 await DateTimeHelper.pickTime(
                          //                     time, context);
                          //             setState(() {});
                          //           },
                          //           child: Text(slot1SelectedEnd == ''
                          //               ? 'Enter Time'
                          //               : slot1SelectedEnd))),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '11:00 AM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      const Text(
                          'Selected start and End time for 2nd slot classes',
                          // (Time from 9:00 to 3:30 are accepted and Friday is a special case for the Time Selection)',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text(
                      //       'From',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 30),
                      //       child: SizedBox(
                      //           width: 150,
                      //           child: ElevatedButton(
                      //               onPressed: () async {
                      //                 slot2SelectedStart =
                      //                     await DateTimeHelper.pickTime(
                      //                         time, context);
                      //                 setState(() {});
                      //               },
                      //               child: Text(slot2SelectedStart == ''
                      //                   ? 'Enter Time'
                      //                   : slot2SelectedStart))),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     const Text(
                      //       'To',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 30),
                      //       child: SizedBox(
                      //           width: 150,
                      //           child: ElevatedButton(
                      //               onPressed: () async {
                      //                 slot2SelectedEnd =
                      //                     await DateTimeHelper.pickTime(
                      //                         time, context);
                      //                 setState(() {});
                      //               },
                      //               child: Text(slot2SelectedEnd == ''
                      //                   ? 'Enter Time'
                      //                   : slot2SelectedEnd))),
                      //     ),
                      //   ],
                      // ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '11:30 PM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30),
                          //   child: SizedBox(
                          //       width: 150,
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             slot1SelectedStart =
                          //                 await DateTimeHelper.pickTime(
                          //                     time, context);
                          //             setState(() {});
                          //           },
                          //           child: Text(slot1SelectedStart == ''
                          //               ? 'Enter Time'
                          //               : slot1SelectedStart))),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'To',
                            style: TextStyle(color: Colors.black),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30),
                          //   child: SizedBox(
                          //       width: 150,
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             slot1SelectedEnd =
                          //                 await DateTimeHelper.pickTime(
                          //                     time, context);
                          //             setState(() {});
                          //           },
                          //           child: Text(slot1SelectedEnd == ''
                          //               ? 'Enter Time'
                          //               : slot1SelectedEnd))),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '1:00 PM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          'Selected start and End time for 3rd slot classes',
                          // (Time from 9:00 to 3:30 are accepted and Friday is a special case for the Time Selection)',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text(
                      //       'From',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 30),
                      //       child: SizedBox(
                      //           width: 150,
                      //           child: ElevatedButton(
                      //               onPressed: () async {
                      //                 slot3SelectedStart =
                      //                     await DateTimeHelper.pickTime(
                      //                         time, context);
                      //                 setState(() {});
                      //               },
                      //               child: Text(slot3SelectedStart == ''
                      //                   ? 'Enter Time'
                      //                   : slot3SelectedStart))),
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     const Text(
                      //       'To',
                      //       style: TextStyle(color: Colors.black),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 30),
                      //       child: SizedBox(
                      //           width: 150,
                      //           child: ElevatedButton(
                      //               onPressed: () async {
                      //                 slot3SelectedEnd =
                      //                     await DateTimeHelper.pickTime(
                      //                         time, context);
                      //                 setState(() {});
                      //               },
                      //               child: Text(slot3SelectedEnd == ''
                      //                   ? 'Enter Time'
                      //                   : slot3SelectedEnd))),
                      //     ),
                      //   ],
                      // ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '1:30 PM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30),
                          //   child: SizedBox(
                          //       width: 150,
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             slot1SelectedStart =
                          //                 await DateTimeHelper.pickTime(
                          //                     time, context);
                          //             setState(() {});
                          //           },
                          //           child: Text(slot1SelectedStart == ''
                          //               ? 'Enter Time'
                          //               : slot1SelectedStart))),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'To',
                            style: TextStyle(color: Colors.black),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30),
                          //   child: SizedBox(
                          //       width: 150,
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             slot1SelectedEnd =
                          //                 await DateTimeHelper.pickTime(
                          //                     time, context);
                          //             setState(() {});
                          //           },
                          //           child: Text(slot1SelectedEnd == ''
                          //               ? 'Enter Time'
                          //               : slot1SelectedEnd))),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '3:00 PM',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // classes
  Widget _buildClass(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleContainer(
            pageTitle: 'Class Selection',
            description:
                'Your department_name classes are already selected if you want another department class for your batches. You can skip the class selection Process if you Dont want other class of Other department_name',
            buttonName: 'Next',
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer(builder: (context, ref, child) {
            ref.read(departmentProvider.notifier).retrieveDepartments();
            ref.read(classProvider.notifier).retrieveClass();
            final department = ref.watch(departmentProvider);
            final classs = ref.watch(classProvider);
            // // Convert departments to a list of maps
            List<Map<String, dynamic>> formattedDepartments =
                department.map((dept) {
              return {
                'department_name': dept.departmentName,
                'department_id': dept.departmentId,
              };
            }).toList();
            List<Map<String, dynamic>> formattedClass = classs.map((dept) {
              return {
                'class_id': dept.classId,
                'department_id': dept.departmentId,
                'class_name': dept.className,
                'class_type': dept.classType
              };
            }).toList();

            for (var i in formattedDepartments) {
              for (var j in formattedClass) {
                if (i['department_id'] == j['department_id']) {
                  j['department_name'] = i['department_name'];
                }
              }
            }

            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: const Offset(0, 1), // Shadow only below
                          blurRadius: 3, // Controls how blurry the shadow is
                          spreadRadius: 0.4, // Spread of the shadow
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    // decoration: BoxDecoration(
                    //     borderRadius: const BorderRadius.only(
                    //         bottomLeft: Radius.circular(5),
                    //         bottomRight: Radius.circular(5)),
                    //     border:
                    //         Border.all(color: Colors.black.withOpacity(0.1))),
                    child: formattedClass.isEmpty
                        ? Center(
                            child: Text(
                              'No Classes! check Database Connectivity',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GroupedListView<dynamic, String>(
                                elements: formattedClass,
                                groupBy: (element) {
                                  return element['department_name'];
                                },
                                order: GroupedListOrder.ASC,
                                groupSeparatorBuilder: (String groupByValue) =>
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 15),
                                      child: Column(
                                        children: [
                                          Text(
                                            groupByValue,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          const Divider()
                                        ],
                                      ),
                                    ),
                                itemBuilder: (context, dynamic element) =>
                                    ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // Background color of the container
                                            borderRadius: BorderRadius.circular(
                                                8), // Optional: rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color with opacity
                                                offset: const Offset(
                                                    0, 1), // Shadow only below
                                                blurRadius:
                                                    3, // Controls how blurry the shadow is
                                                spreadRadius:
                                                    0.4, // Spread of the shadow
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            onDoubleTap: () {
                                              var value = element['class_id'];

                                              bool idExists = selectedClass.any(
                                                  (element) =>
                                                      element['class_id'] ==
                                                      value);

                                              setState(() {
                                                if (idExists) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                              'Class already added')));
                                                } else {
                                                  selectedClass.add({
                                                    'class_type':
                                                        element['class_type'],
                                                    'class_id':
                                                        element['class_id'],
                                                    'department_name': element[
                                                        'department_name'],
                                                    'class_name':
                                                        element['class_name']
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                              'Class added')));
                                                }
                                              });
                                            },
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${element['class_name']}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward),
                      Icon(Icons.arrow_back),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: const Offset(0, 1), // Shadow only below
                          blurRadius: 8, // Controls how blurry the shadow is
                          spreadRadius: 0.10, // Spread of the shadow
                        ),
                      ],
                    ),
                    child: selectedClass.isEmpty
                        ? const Center(
                            child: Text('Double click on a class to add',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal)),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GroupedListView<dynamic, String>(
                                elements: selectedClass,
                                groupBy: (element) {
                                  return element['department_name'];
                                },
                                order: GroupedListOrder.ASC,
                                groupSeparatorBuilder: (String groupByValue) =>
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            groupByValue,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          const Divider()
                                        ],
                                      ),
                                    ),
                                itemBuilder: (context, dynamic element) =>
                                    ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // Background color of the container
                                            borderRadius: BorderRadius.circular(
                                                8), // Optional: rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.2), // Shadow color with opacity
                                                offset: const Offset(
                                                    0, 1), // Shadow only below
                                                blurRadius:
                                                    3, // Controls how blurry the shadow is
                                                spreadRadius:
                                                    0.4, // Spread of the shadow
                                              ),
                                            ],
                                          ),
                                          child: InkWell(
                                            onDoubleTap: () {
                                              (element['class_id']);
                                              var value = element['class_id'];
                                              selectedClass.removeWhere(
                                                  (element) =>
                                                      element['class_id'] ==
                                                      value);
                                              setState(() {});
                                            },
                                            child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${element['class_name']}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge,
                                                          ),
                                                          const Text(
                                                              ' (selected)',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .green)),
                                                        ],
                                                      ),
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            Colors.green[300],
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ));
  }

// teacher
  Widget _buildTeacher(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const TitleContainer(
              pageTitle: 'Teacher Selection',
              description:
                  'Select Teacher(visitor/Other department_name Teacher/Your Own department_name for each subject listed below)',
              buttonName: 'Next',
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer(
              builder: (context, ref, child) {
                ref.read(departmentProvider.notifier).retrieveDepartments();
                ref.read(teacherProvider.notifier).retrieveTeacher();
                final department = ref.watch(departmentProvider);
                final teachersss = ref.watch(teacherProvider);
                // // Convert departments to a list of maps
                List<Map<String, dynamic>> formattedDepartments =
                    department.map((dept) {
                  return {
                    'department_name': dept.departmentName,
                    'department_id': dept.departmentId,
                  };
                }).toList();
                List<Map<String, dynamic>> formattedTeacher =
                    teachersss.map((dept) {
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
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(
                              8), // Optional: rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with opacity
                              offset: const Offset(0, 1), // Shadow only below
                              blurRadius:
                                  3, // Controls how blurry the shadow is
                              spreadRadius: 0.4, // Spread of the shadow
                            ),
                          ],
                        ),
                        child: formattedTeacher.isEmpty
                            ? Center(
                                child: Text(
                                'No Teacher Found',
                                style: Theme.of(context).textTheme.bodySmall,
                              ))
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: GroupedListView<dynamic, String>(
                                    elements: formattedTeacher,
                                    groupBy: (element) {
                                      return element['department_name'];
                                    },
                                    order: GroupedListOrder.ASC,
                                    groupSeparatorBuilder:
                                        (String groupByValue) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    groupByValue,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const Divider()
                                                ],
                                              ),
                                            ),
                                    itemBuilder: (context, dynamic element) =>
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .white, // Background color of the container
                                                borderRadius: BorderRadius.circular(
                                                    8), // Optional: rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(
                                                        0.2), // Shadow color with opacity
                                                    offset: const Offset(0,
                                                        1), // Shadow only below
                                                    blurRadius:
                                                        3, // Controls how blurry the shadow is
                                                    spreadRadius:
                                                        0.4, // Spread of the shadow
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                onDoubleTap: () {
                                                  {
                                                    int value =
                                                        element['teacher_id'];
                                                    bool idExists = selectedTeachers
                                                        .any((element) =>
                                                            element[
                                                                'teacher_id'] ==
                                                            value);
                                                    setState(() {
                                                      if (idExists) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(const SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content: Text(
                                                                    'Teacher already added')));
                                                      } else {
                                                        selectedTeachers.add({
                                                          "teacher_id": element[
                                                              'teacher_id'],
                                                          "teacher_name": element[
                                                              'teacher_name'],
                                                          "email":
                                                              element['email'],
                                                          // "designation":
                                                          //     element['designation'],
                                                          "department_name":
                                                              element[
                                                                  'department_name']
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(const SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content: Text(
                                                                    'Teacher added')));
                                                      }
                                                    });
                                                  }
                                                },
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        '${element['teacher_name']}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayLarge,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_forward),
                          Icon(Icons.arrow_back),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(
                              8), // Optional: rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with opacity
                              offset: const Offset(0, 1), // Shadow only below
                              blurRadius:
                                  3, // Controls how blurry the shadow is
                              spreadRadius: 0.4, // Spread of the shadow
                            ),
                          ],
                        ),
                        child: selectedTeachers.isEmpty
                            ? const Center(
                                child: Text('Double click on a teacher to add',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal)),
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: GroupedListView<dynamic, String>(
                                    elements: selectedTeachers,
                                    groupBy: (element) {
                                      return element['department_name'];
                                    },
                                    order: GroupedListOrder.ASC,
                                    groupSeparatorBuilder:
                                        (String groupByValue) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    groupByValue,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  const Divider()
                                                ],
                                              ),
                                            ),
                                    itemBuilder: (context, dynamic element) =>
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .white, // Background color of the container
                                                borderRadius: BorderRadius.circular(
                                                    8), // Optional: rounded corners
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(
                                                        0.2), // Shadow color with opacity
                                                    offset: const Offset(0,
                                                        1), // Shadow only below
                                                    blurRadius:
                                                        3, // Controls how blurry the shadow is
                                                    spreadRadius:
                                                        0.4, // Spread of the shadow
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                onDoubleTap: () {
                                                  int value =
                                                      element['teacher_id'];
                                                  selectedTeachers.removeWhere(
                                                      (element) =>
                                                          element[
                                                              'teacher_id'] ==
                                                          value);
                                                  setState(() {});
                                                },
                                                child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${element['teacher_name']}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayLarge,
                                                              ),
                                                              const Text(
                                                                  ' (selected)',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .green)),
                                                            ],
                                                          ),
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors
                                                                    .green[300],
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        )),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List timetable = [];
  List timetable2 = [];
  List timetable3 = [];
  List timetable4 = [];
  Widget _buildGenerateTimetable(context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        children: [
          const TitleContainer(
            buttonName: 'Generate Timetable',
            pageTitle: 'Generate Timetable',
            description:
                'When informations are selected completely by clicking the generate button you will be generating the timetable',
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: () {
                  List generatedTimetable1 = [];
                  List generatedTimetable2 = [];

                  List generatedTimetable3 = [];
                  List generatedTimetable4 = [];
                  timetable = [];
                  timetable2 = [];
                  timetable3 = [];
                  timetable4 = [];
                  List newFilteredData = [];
                  List semester1and2 = [];

                  List semester3and4 = [];
                  List semester5and6 = [];
                  List semester7and8 = [];

                  for (var filteredDatamm in filteredDataOdd) {
                    int repetitionCount =
                        1; // Default for 'theory' + 'lab' == 1

                    // Determine the number of times to add based on the sum of 'theory' and 'lab'
                    if (filteredDatamm['theory'] + filteredDatamm['lab'] == 2 ||
                        filteredDatamm['theory'] + filteredDatamm['lab'] == 3) {
                      repetitionCount = 2;
                    } else if (filteredDatamm['theory'] +
                            filteredDatamm['lab'] ==
                        4) {
                      repetitionCount = 3;
                    }

                    // Add the data to newFilteredData based on the repetition count
                    for (int i = 0; i < repetitionCount; i++) {
                      newFilteredData.add({
                        'teacher_id': filteredDatamm['teacher_id'],
                        'teacher_name': filteredDatamm['teacher_name'],
                        'subject_id': filteredDatamm['subject_id'],
                        'subject_name': filteredDatamm['subject_name'],
                        'course_module': filteredDatamm['course_module'],
                        'theory': filteredDatamm['theory'],
                        'lab': filteredDatamm['lab'],
                        'semester': filteredDatamm['semester'],
                        'department_name': filteredDatamm['department_name'],
                      });
                    }
                  }
                  // ----------------------------------------------------------------------------------------

                  // ================================================================================

                  for (var newFilteredDatam in newFilteredData) {
                    // Determine the target list based on the semester
                    List? targetList;
                    if (['semester 01', 'semester 02']
                        .contains(newFilteredDatam['semester'])) {
                      targetList = semester1and2;
                    } else if (['semester 03', 'semester 04']
                        .contains(newFilteredDatam['semester'])) {
                      targetList = semester3and4;
                    } else if (['semester 05', 'semester 06']
                        .contains(newFilteredDatam['semester'])) {
                      targetList = semester5and6;
                    } else if (['semester 07', 'semester 08']
                        .contains(newFilteredDatam['semester'])) {
                      targetList = semester7and8;
                    }

                    // Add to the target list if applicable
                    if (targetList != null) {
                      targetList.add({
                        'id': newFilteredDatam['id'],
                        'teacher_id': newFilteredDatam['teacher_id'],
                        'subject_id': newFilteredDatam['subject_id'],
                        'theory': newFilteredDatam['theory'],
                        'lab': newFilteredDatam['lab'],
                        'subject_name': newFilteredDatam['subject_name'],
                        'teacher_name': newFilteredDatam['teacher_name'],
                        'course_module': newFilteredDatam['course_module'],
                        'semester': newFilteredDatam['semester'],
                        'department_name': newFilteredDatam['department_name'],
                      });
                    }
                  }
                  // =========================================================================================
                  List days = [
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday'
                  ];
                  List welcomeClass1 = [];

                  for (int j = 0; j < selectedClass.length; j++) {
                    for (int k = 0; k < days.length; k++) {
                      welcomeClass1.add({
                        'class_id': selectedClass[j]['class_id'],
                        'day': days[k],
                        'class_name': selectedClass[j]['class_name'],
                        'slot': slot1SelectedStart,
                        'department_name': selectedClass[j]['department_name']
                      });
                      welcomeClass1.add({
                        'class_id': selectedClass[j]['class_id'],
                        'day': days[k],
                        'class_name': selectedClass[j]['class_name'],
                        'slot': slot2SelectedStart,
                        'department_name': selectedClass[j]['department_name']
                      });
                      welcomeClass1.add({
                        'class_id': selectedClass[j]['class_id'],
                        'day': days[k],
                        'class_name': selectedClass[j]['class_name'],
                        'slot': slot3SelectedStart,
                        'department_name': selectedClass[j]['department_name']
                      });
                    }
                  }

                  generatedTimetable1 = [];

                  List classFor12 = List.from(welcomeClass1);
                  List classFor34 = List.from(welcomeClass1);

                  List classFor56 = List.from(welcomeClass1);
                  List classFor78 = List.from(welcomeClass1);

                  classFor12.shuffle();
                  // =============================================================================
                  List itemsToRemove =
                      []; // A separate list to store items to remove

                  for (int sub = 0; sub < semester1and2.length; sub++) {
                    for (var dash in classFor12) {
                      generatedTimetable1.add({
                        'id': semester1and2[sub]['id'],
                        'subject_id': semester1and2[sub]['subject_id'],
                        'subject_name': semester1and2[sub]['subject_name'],
                        'teacher_id': semester1and2[sub]['teacher_id'],
                        'teacher_name': semester1and2[sub]['teacher_name'],
                        'semester': semester1and2[sub]['semester'],
                        'department_name': semester1and2[sub]
                            ['department_name'],
                        'day': dash['day'],
                        'class_name': dash['class_name'],
                        'slot': dash['slot']
                      });

                      for (var item in classFor12) {
                        if (dash['day'].toLowerCase() ==
                                item['day'].toLowerCase() &&
                            dash['slot'].toLowerCase() ==
                                item['slot'].toLowerCase()) {
                          itemsToRemove.add(item); // Mark the item for removal
                        }
                      }

                      break; // Exit the inner loop after adding one entry
                    }

                    // Remove all items marked for deletion
                    classFor12
                        .removeWhere((item) => itemsToRemove.contains(item));
                    itemsToRemove
                        .clear(); // Clear the list for the next iteration
                  }
                  Map<String, List<Map<String, String>>> groupData = {};
                  for (var entry in generatedTimetable1) {
                    String day = entry['day']!;
                    if (!groupData.containsKey(day)) {
                      groupData[day] = [];
                    }

                    groupData[day]!.add({
                      'subject_name': entry['subject_name']!,
                      'teacher_name': entry['teacher_name']!,
                      'class_name': entry['class_name']!,
                      'day': entry['day']!,
                      'slot': entry['slot']!
                    });
                  }

                  for (var day in days) {
                    List<Map<String, String>> dayTimetable =
                        groupData[day] ?? [];
                    timetable.add(dayTimetable);
                  }

                  // 3 and 4 semester schedule----------------------------------------------------

                  for (var gen in generatedTimetable1) {
                    for (var item in classFor34) {
                      if (gen['day'].toLowerCase() ==
                              item['day'].toLowerCase() &&
                          gen['slot'].toLowerCase() ==
                              item['slot'].toLowerCase() &&
                          gen['class_name'] == item['class_name']) {
                        classFor34.remove(item);

                        // Mark the item for removal
                        break;
                      }
                    }

                    // Exit the inner loop after adding one entry
                  }

                  generatedTimetable2 = [];
                  classFor34.shuffle();

                  for (int sub = 0; sub < semester3and4.length; sub++) {
                    bool slotAssigned = false;

                    for (var dash in classFor34) {
                      // Check if the `teacher_id` is already assigned a class in `generatedTimetable1` or `generatedTimetable2` at the same slot
                      bool teacherConflict = generatedTimetable1.any((entry) =>
                              entry['teacher_id'] ==
                                  semester3and4[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']) ||
                          generatedTimetable2.any((entry) =>
                              entry['teacher_id'] ==
                                  semester3and4[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']);

                      // Skip this slot if there's a conflict
                      if (teacherConflict) {
                        continue;
                      }

                      // Assign the slot if no conflict
                      generatedTimetable2.add({
                        'id': semester3and4[sub]['id'],
                        'subject_name': semester3and4[sub]['subject_name'],
                        'teacher_name': semester3and4[sub]['teacher_name'],
                        'teacher_id': semester3and4[sub]
                            ['teacher_id'], // Added for conflict check
                        'semester': semester3and4[sub]['semester'],
                        'department_name': semester3and4[sub]
                            ['department_name'],
                        'day': dash['day'],
                        'class_name': dash['class_name'],
                        'slot': dash['slot']
                      });

                      // Mark items to remove after assigning
                      itemsToRemove.addAll(classFor34.where((item) =>
                          item['day'].toLowerCase() ==
                              dash['day'].toLowerCase() &&
                          item['slot'].toLowerCase() ==
                              dash['slot'].toLowerCase()));

                      slotAssigned = true;
                      break; // Exit the inner loop once a slot is assigned
                    }

                    if (!slotAssigned) {
                      // Retry finding a slot for the same class with remaining available slots
                      for (var dash in classFor34) {
                        // If this point is reached, all conflicting slots have been skipped
                        generatedTimetable2.add({
                          'subject_name': semester3and4[sub]['subject_name'],
                          'teacher_name': semester3and4[sub]['teacher_name'],
                          'teacher_id': semester3and4[sub]['teacher_id'],
                          'semester': semester3and4[sub]['semester'],
                          'department_name': semester3and4[sub]
                              ['department_name'],
                          'day': dash['day'],
                          'class_name': dash['class_name'],
                          'slot': dash['slot']
                        });

                        // Mark items to remove after assigning
                        itemsToRemove.addAll(classFor34.where((item) =>
                            item['day'].toLowerCase() ==
                                dash['day'].toLowerCase() &&
                            item['slot'].toLowerCase() ==
                                dash['slot'].toLowerCase()));

                        slotAssigned = true;
                        break; // Exit the inner loop after assigning the class
                      }
                    }

                    // Remove all marked items from `classFor34`
                    classFor34
                        .removeWhere((item) => itemsToRemove.contains(item));
                    itemsToRemove.clear(); // Clear for the next iteration
                  }

                  // --------------------------------------------------------------------------------------------

                  // ============================================================
                  Map<String, List<Map<String, String>>> groupData2 = {};
                  for (var entry in generatedTimetable2) {
                    String day = entry['day']!;
                    if (!groupData2.containsKey(day)) {
                      groupData2[day] = [];
                    }

                    groupData2[day]!.add({
                      'subject_name': entry['subject_name']!,
                      'teacher_name': entry['teacher_name']!,
                      'class_name': entry['class_name']!,
                      'day': entry['day']!,
                      'slot': entry['slot']!
                    });
                  }

                  for (var day in days) {
                    List<Map<String, String>> dayTimetable =
                        groupData2[day] ?? [];
                    timetable2.add(dayTimetable);
                  }
                  // ---------------------------------------------------------------------------------------------
                  for (var gen in generatedTimetable1) {
                    for (var item in classFor56) {
                      if (gen['day'].toLowerCase() ==
                              item['day'].toLowerCase() &&
                          gen['slot'].toLowerCase() ==
                              item['slot'].toLowerCase() &&
                          gen['class_name'] == item['class_name']) {
                        classFor56.remove(item);

                        // Mark the item for removal
                        break;
                      }
                    }
                    for (var gen in generatedTimetable2) {
                      for (var item in classFor56) {
                        if (gen['day'].toLowerCase() ==
                                item['day'].toLowerCase() &&
                            gen['slot'].toLowerCase() ==
                                item['slot'].toLowerCase() &&
                            gen['class_name'] == item['class_name']) {
                          classFor56.remove(item);

                          // Mark the item for removal
                          break;
                        }
                      }

                      // Exit the inner loop after adding one entry
                    }

                    // Exit the inner loop after adding one entry
                  }
                  classFor56.shuffle();

                  for (int sub = 0; sub < semester5and6.length; sub++) {
                    bool slotAssigned = false;

                    for (var dash in classFor56) {
                      // Check if the `teacher_id` is already assigned a class in `generatedTimetable1`, `generatedTimetable2`, or `generatedTimetable3` at the same slot
                      bool teacherConflict = generatedTimetable1.any((entry) =>
                              entry['teacher_id'] ==
                                  semester5and6[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']) ||
                          generatedTimetable2.any((entry) =>
                              entry['teacher_id'] ==
                                  semester5and6[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']) ||
                          generatedTimetable3.any((entry) =>
                              entry['teacher_id'] ==
                                  semester5and6[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']);

                      // Skip this slot if there's a conflict
                      if (teacherConflict) {
                        continue;
                      }

                      // Assign the slot if no conflict
                      generatedTimetable3.add({
                        'subject_name': semester5and6[sub]['subject_name'],
                        'teacher_name': semester5and6[sub]['teacher_name'],
                        'teacher_id': semester5and6[sub]
                            ['teacher_id'], // Added for conflict check
                        'semester': semester5and6[sub]['semester'],
                        'department_name': semester5and6[sub]
                            ['department_name'],
                        'day': dash['day'],
                        'class_name': dash['class_name'],
                        'slot': dash['slot']
                      });

                      // Mark items to remove after assigning
                      itemsToRemove.addAll(classFor56.where((item) =>
                          item['day'].toLowerCase() ==
                              dash['day'].toLowerCase() &&
                          item['slot'].toLowerCase() ==
                              dash['slot'].toLowerCase()));

                      slotAssigned = true;
                      break; // Exit the inner loop once a slot is assigned
                    }

                    if (!slotAssigned) {
                      // Retry finding a slot for the same class with remaining available slots
                      for (var dash in classFor56) {
                        // If this point is reached, all conflicting slots have been skipped
                        generatedTimetable3.add({
                          'subject_name': semester5and6[sub]['subject_name'],
                          'teacher_name': semester5and6[sub]['teacher_name'],
                          'teacher_id': semester5and6[sub]['teacher_id'],
                          'semester': semester5and6[sub]['semester'],
                          'department_name': semester5and6[sub]
                              ['department_name'],
                          'day': dash['day'],
                          'class_name': dash['class_name'],
                          'slot': dash['slot']
                        });

                        // Mark items to remove after assigning
                        itemsToRemove.addAll(classFor56.where((item) =>
                            item['day'].toLowerCase() ==
                                dash['day'].toLowerCase() &&
                            item['slot'].toLowerCase() ==
                                dash['slot'].toLowerCase()));

                        slotAssigned = true;
                        break; // Exit the inner loop after assigning the class
                      }
                    }

                    // Remove all marked items from `classFor56`
                    classFor56
                        .removeWhere((item) => itemsToRemove.contains(item));
                    itemsToRemove.clear(); // Clear for the next iteration
                  }

// --------------------------------------------------------------------------------------------

// Group generatedTimetable3 by day for display
                  Map<String, List<Map<String, String>>> groupData3 = {};
                  for (var entry in generatedTimetable3) {
                    String day = entry['day']!;
                    if (!groupData3.containsKey(day)) {
                      groupData3[day] = [];
                    }

                    groupData3[day]!.add({
                      'subject_name': entry['subject_name']!,
                      'teacher_name': entry['teacher_name']!,
                      'class_name': entry['class_name']!,
                      'day': entry['day']!,
                      'slot': entry['slot']!
                    });
                  }

// Add the grouped data to `timetable3` for each day
                  for (var day in days) {
                    List<Map<String, String>> dayTimetable =
                        groupData3[day] ?? [];
                    timetable3.add(dayTimetable);
                  }

                  for (var gen in generatedTimetable1) {
                    for (var item in classFor78) {
                      if (gen['day'].toLowerCase() ==
                              item['day'].toLowerCase() &&
                          gen['slot'].toLowerCase() ==
                              item['slot'].toLowerCase() &&
                          gen['class_name'] == item['class_name']) {
                        classFor78.remove(item);

                        // Mark the item for removal
                        break;
                      }
                    }
                  }
                  for (var gen in generatedTimetable2) {
                    for (var item in classFor78) {
                      if (gen['day'].toLowerCase() ==
                              item['day'].toLowerCase() &&
                          gen['slot'].toLowerCase() ==
                              item['slot'].toLowerCase() &&
                          gen['class_name'] == item['class_name']) {
                        classFor78.remove(item);

                        // Mark the item for removal
                        break;
                      }
                    }
                  }
                  for (var gen in generatedTimetable3) {
                    for (var item in classFor78) {
                      if (gen['day'].toLowerCase() ==
                              item['day'].toLowerCase() &&
                          gen['slot'].toLowerCase() ==
                              item['slot'].toLowerCase() &&
                          gen['class_name'] == item['class_name']) {
                        classFor78.remove(item);

                        // Mark the item for removal
                        break;
                      }
                    }
                  }
                  classFor78.shuffle();

                  for (int sub = 0; sub < semester7and8.length; sub++) {
                    bool slotAssigned = false;

                    // Iterate over class slots for semester 7 and 8
                    for (var dash in classFor78) {
                      // Check if the teacher is already assigned a class in any timetable at the same slot
                      bool teacherConflict = generatedTimetable1.any((entry) =>
                              entry['teacher_id'] ==
                                  semester7and8[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']) ||
                          generatedTimetable2.any((entry) =>
                              entry['teacher_id'] ==
                                  semester7and8[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']) ||
                          generatedTimetable3.any((entry) =>
                              entry['teacher_id'] ==
                                  semester7and8[sub]['teacher_id'] &&
                              entry['day'] == dash['day'] &&
                              entry['slot'] == dash['slot']);

                      // Skip the current slot if a conflict is detected
                      if (teacherConflict) {
                        continue;
                      }

                      // Assign the slot if no conflict
                      generatedTimetable4.add({
                        'subject_name': semester7and8[sub]['subject_name'],
                        'teacher_name': semester7and8[sub]['teacher_name'],
                        'teacher_id': semester7and8[sub]
                            ['teacher_id'], // For conflict check
                        'semester': semester7and8[sub]['semester'],
                        'department_name': semester7and8[sub]
                            ['department_name'],
                        'day': dash['day'],
                        'class_name': dash['class_name'],
                        'slot': dash['slot']
                      });

                      // Mark the assigned slot to be removed later
                      itemsToRemove.addAll(classFor78.where((item) =>
                          item['day'].toLowerCase() ==
                              dash['day'].toLowerCase() &&
                          item['slot'].toLowerCase() ==
                              dash['slot'].toLowerCase()));

                      slotAssigned = true;
                      break; // Exit the inner loop after successfully assigning a slot
                    }

                    // Retry slot assignment if the first attempt failed
                    if (!slotAssigned) {
                      for (var dash in classFor78) {
                        bool teacherConflict = generatedTimetable1.any(
                                (entry) =>
                                    entry['teacher_id'] ==
                                        semester7and8[sub]['teacher_id'] &&
                                    entry['day'] == dash['day'] &&
                                    entry['slot'] == dash['slot']) ||
                            generatedTimetable2.any((entry) =>
                                entry['teacher_id'] ==
                                    semester7and8[sub]['teacher_id'] &&
                                entry['day'] == dash['day'] &&
                                entry['slot'] == dash['slot']) ||
                            generatedTimetable3.any((entry) =>
                                entry['teacher_id'] ==
                                    semester7and8[sub]['teacher_id'] &&
                                entry['day'] == dash['day'] &&
                                entry['slot'] == dash['slot']);

                        // Skip the slot if there's a conflict
                        if (teacherConflict) {
                          continue;
                        }

                        // Assign the slot if no conflict
                        generatedTimetable4.add({
                          'subject_name': semester7and8[sub]['subject_name'],
                          'teacher_name': semester7and8[sub]['teacher_name'],
                          'teacher_id': semester7and8[sub]['teacher_id'],
                          'semester': semester7and8[sub]['semester'],
                          'department_name': semester7and8[sub]
                              ['department_name'],
                          'day': dash['day'],
                          'class_name': dash['class_name'],
                          'slot': dash['slot']
                        });

                        // Mark the assigned slot for removal
                        itemsToRemove.addAll(classFor56.where((item) =>
                            item['day'].toLowerCase() ==
                                dash['day'].toLowerCase() &&
                            item['slot'].toLowerCase() ==
                                dash['slot'].toLowerCase()));

                        slotAssigned = true;
                        break; // Exit after assigning a slot
                      }
                    }

                    // Remove assigned slots from the available pool
                    classFor78
                        .removeWhere((item) => itemsToRemove.contains(item));
                    itemsToRemove.clear(); // Clear for the next iteration
                  }
                  Map<String, List<Map<String, String>>> groupData4 = {};
                  for (var entry in generatedTimetable4) {
                    String day = entry['day']!;
                    if (!groupData4.containsKey(day)) {
                      groupData4[day] = [];
                    }

                    groupData4[day]!.add({
                      'subject_name': entry['subject_name']!,
                      'teacher_name': entry['teacher_name']!,
                      'class_name': entry['class_name']!,
                      'day': entry['day']!,
                      'slot': entry['slot']!
                    });
                  }

// Add the grouped data to `timetable3` for each day
                  for (var day in days) {
                    List<Map<String, String>> dayTimetable =
                        groupData4[day] ?? [];
                    timetable4.add(dayTimetable);
                  }
                  setState(() {});
                },
                child: const Text('Generate Timetable')),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  timetable.isEmpty
                      ? const SizedBox.shrink()
                      : const Text(
                          'BSCS 1st',
                          style: TextStyle(color: Colors.black),
                        ),
                  timetable.isEmpty
                      ? const Center(child: Text('No timetable data available'))
                      : buildTimetableView(timetable),
                  const SizedBox(
                    height: 20,
                  ),
                  timetable3.isEmpty
                      ? const SizedBox.shrink()
                      : const Text(
                          'BSCS 3rd',
                          style: TextStyle(color: Colors.black),
                        ),
                  timetable2.isEmpty
                      ? const Center(child: Text('No timetable data available'))
                      : buildTimetableView(timetable2),
                  const SizedBox(
                    height: 20,
                  ),
                  timetable3.isEmpty
                      ? const SizedBox.shrink()
                      : const Text(
                          'BSCS 5th',
                          style: TextStyle(color: Colors.black),
                        ),
                  timetable3.isEmpty
                      ? const Center(child: Text('No timetable data available'))
                      : buildTimetableView(timetable3),
                  const SizedBox(
                    height: 20,
                  ),
                  timetable4.isEmpty
                      ? const SizedBox.shrink()
                      : const Text(
                          'BSCS 7th',
                          style: TextStyle(color: Colors.black),
                        ),
                  timetable4.isEmpty
                      ? const Center(child: Text('No timetable data available'))
                      : buildTimetableView(timetable4),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget buildTimetableView(List timetable) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Header Row for Days
          Row(
            children: [
              // Empty cell for time slots column
              Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Days of the week
              for (String day in [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday'
              ])
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Rows for time slots
          for (String timeSlot in ['9:30 AM', '11:30 AM', '1:30 PM'])
            Row(
              children: [
                // Time slot column
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      timeSlot,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Timetable cells for each day
                for (String day in [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday'
                ])
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Builder(
                        builder: (context) {
                          // Flatten the timetable data
                          var flattenedTimetable =
                              timetable.expand((list) => list).toList();

                          // Find entry for the current day and slot
                          var cellData = flattenedTimetable.firstWhere(
                            (entry) =>
                                entry['day'] == day &&
                                entry['slot'] == timeSlot,
                            orElse: () => null,
                          );

                          // If no data, display "Break"
                          if (cellData == null) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(0.3))),
                              child: const Center(
                                child: Text(
                                  'Break',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          // Display subject, class, teacher, and slot
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.3))),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    cellData['subject_name'] ?? 'N/A',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    cellData['class_name'] ?? 'N/A',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    cellData['teacher_name'] ?? 'N/A',
                                    style:
                                        const TextStyle(color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
