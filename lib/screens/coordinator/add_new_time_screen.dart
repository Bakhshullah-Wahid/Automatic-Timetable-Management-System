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
import '../../wholeData/default_data.dart';
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
  DefaultData defaultData = DefaultData();
  DialogeBoxOpen dialogebox = DialogeBoxOpen();
  String? selectedSem;
  String? selectedDepartment;
  List<Map<String, dynamic>> formattedSubject = [];
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

        for (var i in formattedDepartments) {
          for (var j in formattedSubject) {
            if (i['department_id'] == j['department_id']) {
              j['department_name'] = i['department_name'];
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
  // filteringData() async {
  //   var prefs2 = await SharedPreferences.getInstance();
  //   department = prefs2.getString('department').toString();
  //   for (int i = 0; i < formattedSubject.length; i++) {
  //     if (formattedSubject[i]['department_name'] == department) {
  //       if (selectedSem == 'semester 01') {
  //         if (formattedSubject[i]['semester'] == 'semester 01' ||
  //             formattedSubject[i]['semester'] == 'semester 03' ||
  //             formattedSubject[i]['semester'] == 'semester 05' ||
  //             formattedSubject[i]['semester'] == 'semester 07') {
  //           filteredDataOdd.add(formattedSubject[i]);

  //         }
  //       } else {
  //         if (selectedSem == 'semester 02') {
  //           if (formattedSubject[i]['semester'] == 'semester 02' ||
  //               formattedSubject[i]['semester'] == 'semester 04' ||
  //               formattedSubject[i]['semester'] == 'semester 06' ||
  //               formattedSubject[i]['semester'] == 'semester 08') {
  //             filteredDataEven.add(formattedSubject[i]);
  //           }
  //         }
  //       }
  //     }
  //   }
  //   setState(() {});
  //   print(filteredDataOdd);
  // }

  filteringData() async {
    var prefs2 = await SharedPreferences.getInstance();
    department = prefs2.getString('department').toString();

    for (int i = 0; i < defaultData.wholeSubject.length; i++) {
      if (defaultData.wholeSubject[i]['Department'] == department) {
        if (selectedSem == 'semester 01') {
          if (defaultData.wholeSubject[i]['semester'] == 'semester 01' ||
              defaultData.wholeSubject[i]['semester'] == 'semester 03' ||
              defaultData.wholeSubject[i]['semester'] == 'semester 05' ||
              defaultData.wholeSubject[i]['semester'] == 'semester 07') {
            filteredDataOdd.add(defaultData.wholeSubject[i]);
          }
        } else {
          if (selectedSem == 'semester 02') {
            if (defaultData.wholeSubject[i]['semester'] == 'semester 02' ||
                defaultData.wholeSubject[i]['semester'] == 'semester 04' ||
                defaultData.wholeSubject[i]['semester'] == 'semester 06' ||
                defaultData.wholeSubject[i]['semester'] == 'semester 08') {
              filteredDataEven.add(defaultData.wholeSubject[i]);
            }
          }
        }
      }
    }
    for (int j = 0; j < defaultData.teacherAndDepartment.length; j++) {
      if (defaultData.teacherAndDepartment[j]['Department'] == department) {
        teacherSelection.add(defaultData.teacherAndDepartment[j]);
      } else {
        otherDepartmentTeacher.add(defaultData.teacherAndDepartment[j]);
      }
    }
    teacherSelection.add({"name": "Others"});

    setState(() {});
  }

  DateTimeHelper dateTimeHelper = DateTimeHelper();
  Widget _buildSubject(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleContainer(
            pageTitle: 'Subject Selected',
            description:
                'Select Teacher(visitor/Other Department Teacher/Your Own Department for each subject listed below)',
            buttonName: 'Next',
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                groupByValue,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                        itemBuilder: (context, dynamic element) => ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${element['Title']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                        ),
                                      )),
                                  selectedTeachers.isNotEmpty
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            List selectedTeacher1 =
                                                await dialogebox
                                                    .teacherSelection(
                                                        'Select Teacher',
                                                        context,
                                                        selectedTeachers,
                                                        element['name']);

                                            if (selectedTeacher1[0] != '') {
                                              element['name'] =
                                                  selectedTeacher1[0];
                                              element['teacherId'] =
                                                  selectedTeacher1[1];

                                              setState(() {});
                                            }
                                          },
                                          child: Text(element['name'] == ''
                                              ? 'Select teacher'
                                              : element['name']))
                                      : Container()
                                ],
                              ),
                            )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController timetableName = TextEditingController();
// select semester
  Widget _buildSemesterSelection(BuildContext context) {
    return Scaffold(
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
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  border: Border.all(color: Colors.black.withOpacity(0.1))),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
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
                              labelText: 'Timetable Name',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 10),
                              prefixIcon: const Icon(Icons.schedule,
                                  color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
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
          ),
        ],
      ),
    );
  }

  // classes
  Widget _buildClass(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleContainer(
          pageTitle: 'Class Selection',
          description:
              'Your Department classes are already selected if you want another department class for your batches. You can skip the class selection Process if you Dont want other class of Other Department',
          buttonName: 'Next',
        ),
        const SizedBox(
          height: 3,
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
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      groupByValue,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                              itemBuilder: (context, dynamic element) =>
                                  ListTile(
                                    title: InkWell(
                                      onDoubleTap: () {
                                        var value = element['class_id'];

                                        bool idExists = selectedClass.any(
                                            (element) =>
                                                element['class_id'] == value);

                                        setState(() {
                                          if (idExists) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Class already added')));
                                          } else {
                                            selectedClass.add({
                                              'class_type':
                                                  element['class_type'],
                                              'class_id': element['class_id'],
                                              'department_name':
                                                  element['department_name'],
                                              'class_name':
                                                  element['class_name']
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content:
                                                        Text('Class added')));
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${element['class_name']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                            ),
                                          )),
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
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      border: Border.all(color: Colors.black.withOpacity(0.1))),
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
                                    child: Text(
                                      groupByValue,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                              itemBuilder: (context, dynamic element) =>
                                  ListTile(
                                    title: InkWell(
                                      onDoubleTap: () {
                                        print(element['class_id']);
                                        var value = element['class_id'];
                                        selectedClass.removeWhere((element) =>
                                            element['class_id'] == value);
                                        setState(() {});
                                      },
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${element['class_name']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                            ),
                                          )),
                                    ),
                                  )),
                        ),
                ),
              ],
            ),
          );
        }),
      ],
    ));
  }

// teacher
  Widget _buildTeacher(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TitleContainer(
            pageTitle: 'Teacher Selection',
            description:
                'Select Teacher(visitor/Other Department Teacher/Your Own Department for each subject listed below)',
            buttonName: 'Next',
          ),
          const SizedBox(
            height: 5,
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
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1))),
                      child: formattedTeacher.isEmpty
                          ? Center(
                              child: Text(
                              'No Teacher Found',
                              style: Theme.of(context).textTheme.bodySmall,
                            ))
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: GroupedListView<dynamic, String>(
                                  elements: formattedTeacher,
                                  groupBy: (element) {
                                    return element['department_name'];
                                  },
                                  order: GroupedListOrder.ASC,
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              groupByValue,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ),
                                  itemBuilder: (context, dynamic element) =>
                                      ListTile(
                                        title: InkWell(
                                          onDoubleTap: () {
                                            {
                                              int value = element['teacher_id'];
                                              bool idExists = selectedTeachers
                                                  .any((element) =>
                                                      element['teacher_id'] ==
                                                      value);
                                              setState(() {
                                                if (idExists) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                              'Teacher already added')));
                                                } else {
                                                  selectedTeachers.add({
                                                    "teacher_id":
                                                        element['teacher_id'],
                                                    "teacher_name":
                                                        element['teacher_name'],
                                                    "email": element['email'],
                                                    // "designation":
                                                    //     element['designation'],
                                                    "department_name": element[
                                                        'department_name']
                                                  });
                                                  ScaffoldMessenger.of(context)
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '${element['teacher_name']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                ),
                                              )),
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
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1))),
                      child: selectedTeachers.isEmpty
                          ? const Center(
                              child: Text('Double click on a teacher to add',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: GroupedListView<dynamic, String>(
                                  elements: selectedTeachers,
                                  groupBy: (element) {
                                    return element['department_name'];
                                  },
                                  order: GroupedListOrder.ASC,
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              groupByValue,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ),
                                  itemBuilder: (context, dynamic element) =>
                                      ListTile(
                                        title: InkWell(
                                          onDoubleTap: () {
                                            int value = element['teacher_id'];
                                            selectedTeachers.removeWhere(
                                                (element) =>
                                                    element['teacher_id'] ==
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
                                                child: Text(
                                                  '${element['teacher_name']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge,
                                                ),
                                              )),
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
    );
  }

  List<DataColumn> _dataCome() {
    return [
      const DataColumn(
          label: Text(
        'Time',
        style: TextStyle(color: Colors.black),
      )),
      const DataColumn(
          label: Text(
        'Mon',
        style: TextStyle(color: Colors.black),
      )),
      const DataColumn(
          label: Text(
        'Tue',
        style: TextStyle(color: Colors.black),
      )),
      const DataColumn(
          label: Text(
        'Wed',
        style: TextStyle(color: Colors.black),
      )),
      const DataColumn(
          label: Text(
        'Thu',
        style: TextStyle(color: Colors.black),
      )),
      const DataColumn(
          label: Text(
        'Fri',
        style: TextStyle(color: Colors.black),
      ))
    ];
  }

//Generrate table
  List generatedTimetable1 = [];
  List generatedTimetable2 = [];
  List generatedTimetable3 = [];
  List generatedTimetable4 = [];
  Widget _buildGenerateTimetable(context) {
    return Scaffold(
        body: Column(
      children: [
        const TitleContainer(
          pageTitle: 'Generate Timetable',
          description:
              'When informations are selected completely by clicking the generate button you will be generating the timetable',
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
              onPressed: () {
                List newFilteredData = [];
                List semester1and2 = [];
                List newFilteredDataWithIndex = [];
                List welcomeClass = [];

                List semester3and4 = [];
                List semester5and6 = [];
                List semester7and8 = [];
                for (var filteredDatamm in filteredDataOdd!) {
                  if (filteredDatamm['Theory'] + filteredDatamm['Lab'] == 1) {
                    newFilteredData.add({
                      'teacherId': filteredDatamm['teacherId'],
                      'name': filteredDatamm['name'],
                      'subjectId': filteredDatamm['subjectId'],
                      'Title': filteredDatamm['Title'],
                      'Code': filteredDatamm['Code'],
                      'Theory': filteredDatamm['Theory'],
                      'Lab': filteredDatamm['Lab'],
                      'semester': filteredDatamm['semester'],
                      'Department': filteredDatamm['Department'],
                    });
                  } else if (filteredDatamm['Theory'] + filteredDatamm['Lab'] ==
                          2 ||
                      filteredDatamm['Theory'] + filteredDatamm['Lab'] == 3) {
                    newFilteredData.add({
                      'teacherId': filteredDatamm['teacherId'],
                      'name': filteredDatamm['name'],
                      'subjectId': filteredDatamm['subjectId'],
                      'Title': filteredDatamm['Title'],
                      'Code': filteredDatamm['Code'],
                      'Theory': filteredDatamm['Theory'],
                      'Lab': filteredDatamm['Lab'],
                      'semester': filteredDatamm['semester'],
                      'Department': filteredDatamm['Department'],
                    });
                    newFilteredData.add({
                      'teacherId': filteredDatamm['teacherId'],
                      'name': filteredDatamm['name'],
                      'subjectId': filteredDatamm['subjectId'],
                      'Title': filteredDatamm['Title'],
                      'Code': filteredDatamm['Code'],
                      'Theory': filteredDatamm['Theory'],
                      'Lab': filteredDatamm['Lab'],
                      'semester': filteredDatamm['semester'],
                      'Department': filteredDatamm['Department'],
                    });
                  } else if (filteredDatamm['Theory'] + filteredDatamm['Lab'] ==
                      4) {
                    newFilteredData.add({
                      'teacherId': filteredDatamm['teacherId'],
                      'name': filteredDatamm['name'],
                      'subjectId': filteredDatamm['subjectId'],
                      'Title': filteredDatamm['Title'],
                      'Code': filteredDatamm['Code'],
                      'Theory': filteredDatamm['Theory'],
                      'Lab': filteredDatamm['Lab'],
                      'semester': filteredDatamm['semester'],
                      'Department': filteredDatamm['Department'],
                    });
                    newFilteredData.add({
                      'teacherId': filteredDatamm['teacherId'],
                      'name': filteredDatamm['name'],
                      'subjectId': filteredDatamm['subjectId'],
                      'Title': filteredDatamm['Title'],
                      'Code': filteredDatamm['Code'],
                      'Theory': filteredDatamm['Theory'],
                      'Lab': filteredDatamm['Lab'],
                      'semester': filteredDatamm['semester'],
                      'Department': filteredDatamm['Department'],
                    });
                    newFilteredData.add({
                      'teacherId': filteredDatamm['teacherId'],
                      'name': filteredDatamm['name'],
                      'subjectId': filteredDatamm['subjectId'],
                      'Title': filteredDatamm['Title'],
                      'Code': filteredDatamm['Code'],
                      'Theory': filteredDatamm['Theory'],
                      'Lab': filteredDatamm['Lab'],
                      'semester': filteredDatamm['semester'],
                      'Department': filteredDatamm['Department'],
                    });
                  }
                }

                for (int i = 0; i < newFilteredData.length; i++) {
                  newFilteredDataWithIndex.add({
                    'teacherId': newFilteredData[i]['teacherId'],
                    'subjectId': newFilteredData[i]['subjectId'],
                    'id': i,
                    'Theory': newFilteredData[i]['Theory'],
                    'Lab': newFilteredData[i]['Lab'],
                    'Title': newFilteredData[i]['Title'],
                    'name': newFilteredData[i]['name'],
                    'Code': newFilteredData[i]['Code'],
                    'semester': newFilteredData[i]['semester'],
                    'Department': newFilteredData[i]['Department']
                  });
                }

                for (var newFilteredDatam in newFilteredDataWithIndex) {
                  if (newFilteredDatam['semester'] == 'semester 01' ||
                      newFilteredDatam['semester'] == 'semester 02') {
                    semester1and2.add({
                      'id': newFilteredDatam['id'],
                      'teacherId': newFilteredDatam['teacherId'],
                      'subjectId': newFilteredDatam['subjectId'],
                      'Theory': newFilteredDatam['Theory'],
                      'Lab': newFilteredDatam['Lab'],
                      'Title': newFilteredDatam['Title'],
                      'name': newFilteredDatam['name'],
                      'Code': newFilteredDatam['Code'],
                      'semester': newFilteredDatam['semester'],
                      'Department': newFilteredDatam['Department']
                    });
                  } else if (newFilteredDatam['semester'] == 'semester 03' ||
                      newFilteredDatam['semester'] == 'semester 04') {
                    semester3and4.add({
                      'id': newFilteredDatam['id'],
                      'teacherId': newFilteredDatam['teacherId'],
                      'subjectId': newFilteredDatam['subjectId'],
                      'Theory': newFilteredDatam['Theory'],
                      'Lab': newFilteredDatam['Lab'],
                      'Title': newFilteredDatam['Title'],
                      'name': newFilteredDatam['name'],
                      'Code': newFilteredDatam['Code'],
                      'semester': newFilteredDatam['semester'],
                      'Department': newFilteredDatam['Department']
                    });
                  } else if (newFilteredDatam['semester'] == 'semester 05' ||
                      newFilteredDatam['semester'] == 'semester 06') {
                    semester5and6.add({
                      'id': newFilteredDatam['id'],
                      'teacherId': newFilteredDatam['teacherId'],
                      'subjectId': newFilteredDatam['subjectId'],
                      'Theory': newFilteredDatam['Theory'],
                      'Lab': newFilteredDatam['Lab'],
                      'Title': newFilteredDatam['Title'],
                      'name': newFilteredDatam['name'],
                      'Code': newFilteredDatam['Code'],
                      'semester': newFilteredDatam['semester'],
                      'Department': newFilteredDatam['Department']
                    });
                  } else if (newFilteredDatam['semester'] == 'semester 07' ||
                      newFilteredDatam['semester'] == 'semester 08') {
                    semester7and8.add({
                      'id': newFilteredDatam['id'],
                      'teacherId': newFilteredDatam['teacherId'],
                      'subjectId': newFilteredDatam['subjectId'],
                      'Theory': newFilteredDatam['Theory'],
                      'Lab': newFilteredDatam['Lab'],
                      'Title': newFilteredDatam['Title'],
                      'name': newFilteredDatam['name'],
                      'Code': newFilteredDatam['Code'],
                      'semester': newFilteredDatam['semester'],
                      'Department': newFilteredDatam['Department']
                    });
                  }
                }

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
                      'day': days[k],
                      'class_name': selectedClass[j]['class_name'],
                      'slot': slot1SelectedStart
                    });
                    welcomeClass1.add({
                      'day': days[k],
                      'class_name': selectedClass[j]['class_name'],
                      'slot': slot2SelectedStart
                    });
                    welcomeClass1.add({
                      'day': days[k],
                      'class_name': selectedClass[j]['class_name'],
                      'slot': slot3SelectedStart
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
                      'Title': semester1and2[sub]['Title'],
                      'name': semester1and2[sub]['name'],
                      'semester': semester1and2[sub]['semester'],
                      'Department': semester1and2[sub]['Department'],
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

                // 3 and 4 semester schedule----------------------------------------------------

                for (var gen in generatedTimetable1) {
                  for (var item in classFor34) {
                    if (gen['day'].toLowerCase() == item['day'].toLowerCase() &&
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

                classFor34.shuffle();
                for (int sub = 0; sub < semester3and4.length; sub++) {
                  for (var dash in classFor34) {
                    generatedTimetable1.add({
                      'id': semester3and4[sub]['id'],
                      'Title': semester3and4[sub]['Title'],
                      'name': semester3and4[sub]['name'],
                      'semester': semester3and4[sub]['semester'],
                      'Department': semester3and4[sub]['Department'],
                      'day': dash['day'],
                      'class_name': dash['class_name'],
                      'slot': dash['slot']
                    });

                    for (var item in classFor34) {
                      if (dash['day'].toLowerCase() ==
                              item['day'].toLowerCase() &&
                          dash['slot'].toLowerCase() ==
                              item['slot'].toLowerCase()) {
                        itemsToRemove.add(item);
                        // Mark the item for removal
                      }
                    }

                    break; // Exit the inner loop after adding one entry
                  }

                  // Remove all items marked for deletion
                  classFor34
                      .removeWhere((item) => itemsToRemove.contains(item));
                  itemsToRemove
                      .clear(); // Clear the list for the next iteration
                }
                // ---------------------------------------------------------------------------------------------
                for (var gen in generatedTimetable1) {
                  for (var item in classFor56) {
                    if (gen['day'].toLowerCase() == item['day'].toLowerCase() &&
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

                // for (int remove = 0; remove < generatedTimetable1.length;remove++){

                // }
                classFor56.shuffle();
                for (int sub = 0; sub < semester5and6.length; sub++) {
                  for (var dash in classFor56) {
                    generatedTimetable1.add({
                      'id': semester5and6[sub]['id'],
                      'Title': semester5and6[sub]['Title'],
                      'name': semester5and6[sub]['name'],
                      'semester': semester5and6[sub]['semester'],
                      'Department': semester5and6[sub]['Department'],
                      'day': dash['day'],
                      'class_name': dash['class_name'],
                      'slot': dash['slot']
                    });

                    for (var item in classFor56) {
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
                  classFor56
                      .removeWhere((item) => itemsToRemove.contains(item));
                  itemsToRemove
                      .clear(); // Clear the list for the next iteration
                }
                // --------------------------------------------------------------------------------------------
                for (var gen in generatedTimetable1) {
                  for (var item in classFor78) {
                    if (gen['day'].toLowerCase() == item['day'].toLowerCase() &&
                        gen['slot'].toLowerCase() ==
                            item['slot'].toLowerCase() &&
                        gen['class_name'] == item['class_name']) {
                      classFor78.remove(item);

                      // Mark the item for removal
                      break;
                    }
                  }

                  // Exit the inner loop after adding one entry
                }
                classFor78.shuffle();
                for (int sub = 0; sub < semester7and8.length; sub++) {
                  for (var dash in classFor78) {
                    generatedTimetable1.add({
                      'id': semester7and8[sub]['id'],
                      'Title': semester7and8[sub]['Title'],
                      'name': semester7and8[sub]['name'],
                      'semester': semester7and8[sub]['semester'],
                      'Department': semester7and8[sub]['Department'],
                      'day': dash['day'],
                      'class_name': dash['class_name'],
                      'slot': dash['slot']
                    });

                    for (var item in classFor78) {
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
                  classFor78
                      .removeWhere((item) => itemsToRemove.contains(item));
                  itemsToRemove
                      .clear(); // Clear the list for the next iteration
                }

                setState(() {});
              },
              child: const Text('Generate Timetable')),
        ),
        generatedTimetable1.isEmpty
            ? Container()
            : Expanded(
                child: GroupedListView(
                  elements: generatedTimetable1,
                  groupBy: (element) => element['semester'] ?? '',
                  order: GroupedListOrder.ASC,
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      groupByValue,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  itemBuilder: (context, dynamic element) => ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${element['slot']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Column(
                          children: [
                            Text(
                              element['Title'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              element['name'],
                              style: const TextStyle(color: Colors.red),
                            ),
                            Text(
                              element['class_name'],
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        Text(
                          element['semester'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text(
                          element['day'],
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          element['slot'],
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        generatedTimetable2.isEmpty
            ? Container()
            : Expanded(
                child: GroupedListView(
                  elements: generatedTimetable2,
                  groupBy: (element) => element['semester'] ?? '',
                  order: GroupedListOrder.ASC,
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      groupByValue,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  itemBuilder: (context, dynamic element) => ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${element['slot']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Column(
                          children: [
                            Text(
                              element['Title'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              element['name'],
                              style: const TextStyle(color: Colors.red),
                            ),
                            Text(
                              element['class_name'],
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                        Text(
                          element['semester'],
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text(
                          element['day'],
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          element['slot'],
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              )
      ],
    ));
  }

  List<DataRow> createRow() {
    return generatedTimetable1
        .map((e) => DataRow(cells: [
              DataCell(Text(
                e['slot']?.toString() ??
                    'N/A', // Access 'slot' using map notation
                style: const TextStyle(color: Colors.black),
              )),
              DataCell(Text(
                e['Title']?.toString() ??
                    'N/A', // Access 'Title' using map notation
                style: const TextStyle(color: Colors.black),
              )),
              DataCell(Text(
                e['Title']?.toString() ?? 'N/A',
                style: const TextStyle(color: Colors.black),
              )),
              DataCell(Text(
                e['Title']?.toString() ?? 'N/A',
                style: const TextStyle(color: Colors.black),
              )),
              DataCell(Text(
                e['Title']?.toString() ?? 'N/A',
                style: const TextStyle(color: Colors.black),
              )),
              DataCell(Text(
                e['Title']?.toString() ?? 'N/A',
                style: const TextStyle(color: Colors.black),
              ))
            ]))
        .toList();
  }
}
