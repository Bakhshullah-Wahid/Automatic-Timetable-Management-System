import 'package:attms/provider/add_new_time_provider.dart';
import 'package:attms/utils/date_time.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive.dart';
import '../../route/navigations.dart';
import '../../services/class/fetch_class_data.dart';
import '../../services/freeSlots/retrieve_free_slot.dart';
import '../../utils/containor.dart';
import '../../utils/data/fetching_data.dart';
import '../../utils/timetable_arrangement.dart';
import '../../utils/timetable_design.dart';
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
  List selectedTeachers = [];
  DialogeBoxOpen dialogebox = DialogeBoxOpen();
  final FetchingDataCall fetchingDataCall = FetchingDataCall();
  final TimingManage timetableManaging = TimingManage();
  DateTimeHelper dateTimeHelper = DateTimeHelper();
  String? selectedSem;
  String? selectedDepartment;
  List<Map<String, dynamic>> formattedSubject = [];
  List<Map<String, dynamic>> formattedTeacher = [];
  var reference;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        reference = ref;
        final position = ref.watch(addNewTimetableProvider);
        var formattedDepartments = fetchingDataCall.department(ref);
        formattedSubject = fetchingDataCall.subject(ref);
        formattedTeacher = fetchingDataCall.teacher(ref);

        for (var i in formattedDepartments) {
          for (var j in formattedSubject) {
            if (i['department_id'] == j['department_id']) {
              j['department_name'] = i['department_name'];
              j['department_id'] = i['department_id'];
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
                ? _buildClass(context, formattedDepartments)
                : position == 2
                    ? _buildTeacher(context, formattedDepartments)
                    : position == 3
                        ? _buildSubject(context)
                        : _buildGenerateTimetable(context);
      },
    );
  }

  TimeOfDay time = TimeOfDay.now();
// subject
  List filteredDataEven = [];
  List filteredDataOdd = [];
  List teacherSelection = [];
  List otherDepartmentTeacher = [];
  String department = '';
  int deptId = 0;
  bool _isTapped = false;
  filteringData() async {
    var prefs2 = await SharedPreferences.getInstance();
    department = prefs2.getString('department').toString();
    deptId = prefs2.getInt('deptId')!;
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
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Divider()
                            ],
                          ),
                        ),
                        itemBuilder: (context, dynamic element) => ListTile(
                          trailing: selectedTeachers.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () async {
                                    List selectedTeacher1 =
                                        await dialogebox.teacherSelection(
                                            'Select Teacher',
                                            context,
                                            selectedTeachers,
                                            element['teacher_name']);

                                    if (selectedTeacher1[0] != '' ||
                                        selectedTeacher1[0] != null) {
                                      element['teacher_name'] =
                                          selectedTeacher1[0];
                                      element['teacher_id'] =
                                          selectedTeacher1[1];
                                      element['teacher_department'] =
                                          selectedTeacher1[2];

                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(Icons.edit)),
                          title: Column(
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TheContainer(
                                      height: Responsive.isMobile(context)
                                          ? MediaQuery.of(context).size.height *
                                              0.04
                                          : null,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(element['subject_name'],
                                                  // '${element['subject_name']}',
                                                  style: !Responsive.isMobile(
                                                          context)
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .displayLarge
                                                      : TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 8)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // TheContainer(
                        //   width: MediaQuery.of(context).size.width * 0.4,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 5.0, vertical: 2),
                        //     child: TextFormField(
                        //       autovalidateMode:
                        //           AutovalidateMode.onUserInteraction,
                        //       validator: (value) {
                        //         if (value!.isEmpty) {
                        //           return 'Name is required';
                        //         } else {
                        //           return null;
                        //         }
                        //       },
                        //       controller: timetableName,
                        //       cursorHeight: 20,
                        //       style: const TextStyle(
                        //           fontSize: 15, color: Colors.black),
                        //       decoration: InputDecoration(
                        //         errorStyle: const TextStyle(
                        //           color: Colors.red,
                        //           fontSize: 12,
                        //         ),

                        //         labelText: 'Timetable Name',
                        //         labelStyle: const TextStyle(
                        //             fontSize: 10, color: Colors.black),
                        //         hintStyle: const TextStyle(fontSize: 10),
                        //         prefixIcon: const Icon(Icons.schedule,
                        //             color: Colors.black),
                        //         prefixStyle: const TextStyle(fontSize: 10),
                        //         border: InputBorder.none,
                        //         //  OutlineInputBorder(
                        //         //   borderRadius: BorderRadius.circular(12.0),
                        //         // ),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(12.0),
                        //             borderSide: BorderSide.none),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'To',
                              style: TextStyle(color: Colors.black),
                            ),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'To',
                              style: TextStyle(color: Colors.black),
                            ),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'To',
                              style: TextStyle(color: Colors.black),
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List welcomeClass1 = [];
  freeSlotsAdd(freeSlots, type, idOfClass, departmentsName, classeName) {
    for (int j = 0; j < freeSlots.length; j++) {
      welcomeClass1.add({
        'slot_id': freeSlots[j]['id'],
        'class_id': idOfClass,
        'day_of_week': freeSlots[j]['day_of_week'],
        'class_name': classeName,
        'slot': freeSlots[j]['free_slots'],
        'class_department': departmentsName
      });
    }
  }

  // classes
  Widget _buildClass(BuildContext context, formattedDepartments) {
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
            var formattedClass = fetchingDataCall.classs(ref);
            for (var i in formattedDepartments) {
              for (var j in formattedClass) {
                if (i['department_id'] == j['department_id']) {
                  j['department_name'] = i['department_name'];
                }
              }
            }
            formattedClass.removeWhere((element) =>
                (element['department_name'] != department &&
                    element['given_to'] != department));

            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TheContainer(
                      // height: MediaQuery.of(context).size.height * 0.4,
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.8
                          : MediaQuery.of(context).size.width * 0.4,
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
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Padding(
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
                                          padding: const EdgeInsets.only(
                                              top: 20.0, bottom: 10),
                                          child: TheContainer(
                                            height: Responsive.isMobile(context)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04
                                                : null,
                                            child: InkWell(
                                              onDoubleTap: () async {
                                                var value = element['class_id'];

                                                bool idExists = selectedClass
                                                    .any((element) =>
                                                        element['class_id'] ==
                                                        value);

                                                if (idExists) {
                                                  welcomeClass1.removeWhere(
                                                      (element) =>
                                                          element['class_id'] ==
                                                          value);
                                                  selectedClass.removeWhere(
                                                      (element) =>
                                                          element['class_id'] ==
                                                          value);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          backgroundColor:
                                                              Colors.red,
                                                          content: Text(
                                                              'Class Removed')));
                                                } else {
                                                  final freeSlots =
                                                      await fetchFreeSlots(
                                                          element['class_id']);
                                                  await freeSlotsAdd(
                                                      freeSlots,
                                                      element['class_type'],
                                                      element['class_id'],
                                                      element[
                                                          'department_name'],
                                                      element['class_name']);
                                                  selectedClass.add({
                                                    'class_type':
                                                        element['class_type'],
                                                    'class_id':
                                                        element['class_id'],
                                                    'department_name': element[
                                                        'department_name'],
                                                    'class_name':
                                                        element['class_name'],
                                                    'requested_by':
                                                        element['requested_by'],
                                                    'given_to':
                                                        element['given_to'],
                                                    'department_id':
                                                        element['department_id']
                                                  });
                                                }
                                                setState(() {});
                                              },
                                              child: SizedBox(
                                                  width: MediaQuery.of(context)
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
                                                        Text(
                                                          '${element['class_name']}',
                                                          style: !Responsive
                                                                  .isMobile(
                                                                      context)
                                                              ? Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .displayLarge
                                                              : TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 10),
                                                        ),
                                                        if (selectedClass.any(
                                                            (e) =>
                                                                e['class_id'] ==
                                                                element[
                                                                    'class_id']))
                                                          const Text(
                                                              ' (selected)',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .green)),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      )),
                            ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!Responsive.isMobile(context))
                        Icon(Icons.arrow_forward),
                      if (!Responsive.isMobile(context)) Icon(Icons.arrow_back),
                    ],
                  ),
                  (!Responsive.isMobile(context))
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TheContainer(
                              // height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: selectedClass.isEmpty
                                  ? const Center(
                                      child: Text(
                                          'Double click on a class to add',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal)),
                                    )
                                  : SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: GroupedListView<dynamic, String>(
                                          elements: selectedClass,
                                          groupBy: (element) {
                                            return element['department_name'];
                                          },
                                          order: GroupedListOrder.ASC,
                                          groupSeparatorBuilder: (String
                                                  groupByValue) =>
                                              Padding(
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
                                          itemBuilder: (context,
                                                  dynamic element) =>
                                              ListTile(
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: TheContainer(
                                                    child: InkWell(
                                                      onDoubleTap: () {
                                                        (element['class_id']);
                                                        var value =
                                                            element['class_id'];
                                                        welcomeClass1.removeWhere(
                                                            (element) =>
                                                                element[
                                                                    'class_id'] ==
                                                                value);
                                                        selectedClass.removeWhere(
                                                            (element) =>
                                                                element[
                                                                    'class_id'] ==
                                                                value);
                                                        setState(() {});
                                                      },
                                                      child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
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
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.green)),
                                                                  ],
                                                                ),
                                                                CircleAvatar(
                                                                  radius: 15,
                                                                  backgroundColor:
                                                                      Colors.green[
                                                                          300],
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .check,
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
                                    )),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            );
          }),
        ],
      ),
    ));
  }

// teacher
  Widget _buildTeacher(BuildContext context, formattedDepartments) {
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
                var formattedTeacher = fetchingDataCall.teacher(ref);
                for (var i in formattedDepartments) {
                  for (var j in formattedTeacher) {
                    if (i['department_id'] == j['department_id']) {
                      j['department_name'] = i['department_name'];
                    }
                  }
                }
                formattedTeacher.removeWhere((element) =>
                    (element['department_name'] != department &&
                        element['given_to'] != department));
                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TheContainer(
                          width: Responsive.isMobile(context)
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width * 0.4,
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
                                                  top: 20.0, bottom: 10),
                                              child: TheContainer(
                                                height:
                                                    Responsive.isMobile(context)
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04
                                                        : null,
                                                child: InkWell(
                                                  onDoubleTap: () {
                                                    int value =
                                                        element['teacher_id'];
                                                    bool idExists = selectedTeachers
                                                        .any((element) =>
                                                            element[
                                                                'teacher_id'] ==
                                                            value);
                                                    setState(() {
                                                      if (idExists) {
                                                        selectedTeachers
                                                            .removeWhere(
                                                                (element) =>
                                                                    element[
                                                                        'teacher_id'] ==
                                                                    value);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(const SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content: Text(
                                                                    'Teacher Removed')));
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
                                                  },
                                                  child: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.55,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${element['teacher_name']}',
                                                              style: !Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displayLarge
                                                                  : TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          10),
                                                            ),
                                                            if (selectedTeachers.any((e) =>
                                                                e['teacher_id'] ==
                                                                element[
                                                                    'teacher_id']))
                                                              const Text(
                                                                  ' (selected)',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .green)),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!Responsive.isMobile(context))
                            Icon(Icons.arrow_forward),
                          if (!Responsive.isMobile(context))
                            Icon(Icons.arrow_back),
                        ],
                      ),
                      if (!Responsive.isMobile(context))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TheContainer(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: selectedTeachers.isEmpty
                                ? const Center(
                                    child: Text(
                                        'Double click on a teacher to add',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal)),
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
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
                                        itemBuilder: (context,
                                                dynamic element) =>
                                            ListTile(
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20.0),
                                                child: TheContainer(
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
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.55,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
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
                                                                          color:
                                                                              Colors.green)),
                                                                ],
                                                              ),
                                                              CircleAvatar(
                                                                radius: 15,
                                                                backgroundColor:
                                                                    Colors.green[
                                                                        300],
                                                                child:
                                                                    const Center(
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

  List generatedTimetable1 = [];
  List generatedTimetable2 = [];
  List generatedTimetable3 = [];
  List generatedTimetable4 = [];
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
          TitleContainer(
            timetableItself: triggerTimetableGeneration,
            buttonName: 'Generate Timetable',
            pageTitle: 'Generate Timetable',
            description:
                'When informations are selected completely by clicking the generate button you will be generating the timetable',
          ),
          timetable.isEmpty
              ? SizedBox.shrink()
              : TimetableDesigning(
                  timetable: Responsive.isMobile(context)
                      ? generatedTimetable1
                      : timetable,
                  timetable2: Responsive.isMobile(context)
                      ? generatedTimetable2
                      : timetable2,
                  timetable3: Responsive.isMobile(context)
                      ? generatedTimetable3
                      : timetable3,
                  timetable4: Responsive.isMobile(context)
                      ? generatedTimetable4
                      : timetable4,
                  department: department,
                ),
          SizedBox(height: 20),
          timetable.isEmpty
              ? const SizedBox.shrink()
              : Consumer(builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      _onPressed(ref);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: _isTapped
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('Save The Timetable'),
                  );
                }),
        ],
      ),
    ));
  }

  triggerTimetableGeneration() {
    if (selectedSem == null) {
      reference.read(addNewTimetableProvider.notifier).setPosition(0);
    }
    timetable = [];
    timetable2 = [];
    timetable3 = [];
    timetable4 = [];
    List newFilteredData = [];
    List semester1and2 = [];
    List semester3and4 = [];
    List semester5and6 = [];
    List semester7and8 = [];

    for (var filteredDatamm
        in selectedSem == 'semester 01' ? filteredDataOdd : filteredDataEven) {
      int repetitionCount = 1;

      // Determine the number of times to add based on the sum of 'theory' and 'lab'
      if (filteredDatamm['theory'] + filteredDatamm['lab'] == 2 ||
          filteredDatamm['theory'] + filteredDatamm['lab'] == 3) {
        repetitionCount = 2;
      } else if (filteredDatamm['theory'] + filteredDatamm['lab'] == 4) {
        repetitionCount = 3;
      }
      // Add the data to newFilteredData based on the repetition count
      for (int i = 0; i < repetitionCount; i++) {
        newFilteredData.add({
          'teacher_id': filteredDatamm['teacher_id'],
          'teacher_name': filteredDatamm['teacher_name'],
          'teacher_department': filteredDatamm['department_name'],
          'subject_id': filteredDatamm['subject_id'],
          'department_id': filteredDatamm['department_id'],
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
    if (welcomeClass1.length < newFilteredData.length ||
        welcomeClass1.isEmpty) {
      reference.read(addNewTimetableProvider.notifier).setPosition(1);
    } else {
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
            'teacher_id': newFilteredDatam['teacher_id'],
            'subject_id': newFilteredDatam['subject_id'],
            'theory': newFilteredDatam['theory'],
            'lab': newFilteredDatam['lab'],
            'subject_name': newFilteredDatam['subject_name'],
            'teacher_department': newFilteredDatam['teacher_department'],
            'teacher_name': newFilteredDatam['teacher_name'],
            'course_module': newFilteredDatam['course_module'],
            'semester': newFilteredDatam['semester'],
            'department_name': newFilteredDatam['department_name'],
            'department_id': newFilteredDatam['department_id'],
          });
        }
      }

      generatedTimetable1 = [];
      List classFor12 = List.from(welcomeClass1);
      List classFor34 = List.from(welcomeClass1);
      List classFor56 = List.from(welcomeClass1);
      List classFor78 = List.from(welcomeClass1);
      generatedTimetable1 = [];
      generatedTimetable1 = timetableManaging.timetableGenerate(
          classFor12, semester1and2, generatedTimetable1);
      timetable = timetableManaging.timetableDesignSheeet(generatedTimetable1);
      classFor34 = timetableManaging.removeBookedClasses(
          classFor34, generatedTimetable1);
      generatedTimetable2 = timetableManaging.timetableGenerate(
          classFor34, semester3and4, generatedTimetable1);
      timetable2 = timetableManaging.timetableDesignSheeet(generatedTimetable2);
      List generatedTimetableNone = [];
      generatedTimetableNone = generatedTimetable1 + generatedTimetable2;
      classFor56 = timetableManaging.removeBookedClasses(
          classFor56, generatedTimetableNone);
      generatedTimetable3 = timetableManaging.timetableGenerate(
          classFor56, semester5and6, generatedTimetableNone);
      timetable3 = timetableManaging.timetableDesignSheeet(generatedTimetable3);
      generatedTimetableNone = [];
      generatedTimetableNone =
          generatedTimetable1 + generatedTimetable2 + generatedTimetable3;
      classFor78 = timetableManaging.removeBookedClasses(
          classFor78, generatedTimetableNone);
      generatedTimetable4 = timetableManaging.timetableGenerate(
          classFor78, semester7and8, generatedTimetableNone);
      timetable4 = timetableManaging.timetableDesignSheeet(generatedTimetable4);

      setState(() {});
    }
  }

  void _onPressed(ref) async {
    await timetableManaging.savingTimetable(generatedTimetable1, deptId);
    await timetableManaging.savingTimetable(generatedTimetable2, deptId);
    await timetableManaging.savingTimetable(generatedTimetable3, deptId);
    await timetableManaging.savingTimetable(generatedTimetable4, deptId);
    ClassService c = ClassService();
    for (var virtual in selectedClass) {
      if (virtual['given_to'] == department) {
        c.updateClass(virtual['class_id'], virtual['class_name'],
            virtual['class_type'], virtual['department_id'], '', '');
      }
    }
    setState(() {
      _isTapped = true;
    });

    // Simulate some loading process with a delay
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isTapped = false;
      });
    });
    showLoadingDialog(context, ref);
  }

  void showLoadingDialog(BuildContext context, ref) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => AlertDialog(
        content: Text('Timetable Saved'),
        actions: [
          TextButton(
              onPressed: () {
                ref.read(addNewTimetableProvider.notifier).setPosition(0);
                Navigator.pop(context);
                context.go(Routes.home);
              },
              child: Text('ok'))
        ],
      ),
    );
  }
}
