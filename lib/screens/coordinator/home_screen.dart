import 'package:attms/provider/dashboard_provider.dart';
import 'package:attms/services/freeSlots/fetch_free_slots.dart';
import 'package:attms/services/timetable/fetch_timetable.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive.dart';
import '../../utils/data/fetching_data.dart';
import '../../utils/saving_pdf.dart';
import '../../utils/timetable_arrangement.dart';
import '../../utils/timetable_design.dart';
import '../../widget/coordinator/drawer_box.dart';
import '../../widget/dialoge_box.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  String department = '';
  int departmentId = 0;
  filteringData() async {
    var prefs2 = await SharedPreferences.getInstance();
    var prefs = await SharedPreferences.getInstance();
    department = prefs2.getString('department').toString();
    departmentId = prefs.getInt('deptId')!;

    setState(() {});
  }

  List timetable1 = [];
  List timetable2 = [];
  List timetable3 = [];
  List timetable4 = [];
  List<Map<String, dynamic>> semester01And02 = [];
  List<Map<String, dynamic>> semester03And04 = [];
  List<Map<String, dynamic>> semester05And06 = [];
  List<Map<String, dynamic>> semester07And08 = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    journal();

    Future.delayed(Duration(seconds: 3), () {
      _isLoading = false;
      setState(() {}); // Hide the circular indicator after 3 seconds
    });
    setState(() {});
  }

  journal() async {
    timetable1 = [];
    timetable2 = [];
    timetable3 = [];
    timetable4 = [];
    semester03And04.clear();
    semester01And02.clear();
    semester05And06.clear();
    semester07And08.clear();
    await filteringData();
  }

  final ScheduleService scheduleService = ScheduleService();
  final FreeSlotServices free = FreeSlotServices();
  final FetchingDataCall fetchingDataCall = FetchingDataCall();
  final TimingManage timetableManaging = TimingManage();

  bool k = true;
  @override
  Widget build(BuildContext context) {
    // var mediaquery = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, child) {
      final bool mobileCheck = ref.watch(mobileDrawer);
      if (k) {
        semester01And02.clear();
        semester03And04.clear();
        semester05And06.clear();
        semester07And08.clear();

        var formattedTimetable = fetchingDataCall.timetables(ref, departmentId);

        if (formattedTimetable.isNotEmpty) {
          // var formattedDepartment = fetchingDataCall.department(ref);
          var formattedClass = fetchingDataCall.classs(ref);

          var formattedSubject = fetchingDataCall.subject(ref);
          var formattedTeacher = fetchingDataCall.teacher(ref);

          for (var i in formattedTimetable) {
            for (var j in formattedClass) {
              if (i['class_id'] == j['class_id']) {
                i['class_name'] = j['class_name'];
              }
            }
            for (var j in formattedTeacher) {
              if (i['teacher_id'] == j['teacher_id']) {
                i['teacher_name'] = j['teacher_name'];
              }
            }
            for (var j in formattedSubject) {
              if (i['subject_id'] == j['subject_id']) {
                i['subject_name'] = j['subject_name'];
              }
            }
          }

          for (var item in formattedTimetable) {
            if (item['semester'] == 'semester 01' ||
                item['semester'] == 'semester 02') {
              semester01And02.add(item);
            } else if (item['semester'] == 'semester 03' ||
                item['semester'] == 'semester 04') {
              semester03And04.add(item);
            } else if (item['semester'] == 'semester 05' ||
                item['semester'] == 'semester 06') {
              semester05And06.add(item);
            } else if (item['semester'] == 'semester 07' ||
                item['semester'] == 'semester 08') {
              semester07And08.add(item);
            }
          }
          b();
        }
      }

      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  TitleContainer(
                    description: 'Add/View/Delete Timetable',
                    timetableItself: dialoge,
                    pageTitle: timetable1.isEmpty ? 'Dashboard' : 'Dashboard ',
                    buttonName: timetable1.isEmpty
                        ? 'Add New Timetable'
                        : 'Delete Timetable',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                timetable1.isNotEmpty?  TextButton(
                      onPressed: () async {
                        bool b = false;
                        while (!b) {
                          b = await TimetablePdfGenerator(
                                  timetableData1: timetable1,
                                  timetableData2: timetable2,
                                  timetableData3: timetable3,
                                  timetableData4: timetable4,
                                  department: department)
                              .generateTimetablePdf();
                        }
                      },
                      child: Text('convert to pdf')):SizedBox.shrink(),
                  _isLoading
                      ? CircularProgressIndicator()
                      : timetable1.isEmpty || semester01And02.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.45),
                              child: Center(
                                child: Text('No Timetable!',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal)),
                              ),
                            )
                          : TimetableDesigning(
                              timetable: Responsive.isMobile(context)
                                  ? semester01And02
                                  : timetable1,
                              timetable2: Responsive.isMobile(context)
                                  ? semester03And04
                                  : timetable2,
                              timetable3: Responsive.isMobile(context)
                                  ? semester05And06
                                  : timetable3,
                              timetable4: Responsive.isMobile(context)
                                  ? semester07And08
                                  : timetable4,
                              department: department,
                            ),
                ],
              ),
              mobileCheck ? DrawerBox() : SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }

  Future<void> dialoge() async {
    DialogeBoxOpen deletes = DialogeBoxOpen();
    k = false;
    bool isDelete = await deletes.deleteBox('Timetable', context);
    if (isDelete) {
      await calling();
      k = true;
    } else {
      setState(() {
        k = true;
      });
    }
  }

  calling() async {
    await addSlots(semester01And02);
    await addSlots(semester03And04);
    await addSlots(semester05And06);
    await addSlots(semester07And08);
    semester01And02.clear();
    semester03And04.clear();
    semester05And06.clear();
    semester07And08.clear();
    timetable1.clear();
    timetable2.clear();
    timetable3.clear();
    timetable4.clear();
    bool isDelete = false;
    while (!isDelete) {
      isDelete = await scheduleService.deleteTimetable(departmentId);
    }
    setState(() {});
  }

  Future<void> addSlots(semester) async {
    for (var i in semester) {
      bool addSlot = false;
      while (!addSlot) {
        addSlot = await free.addFreeSlot(
            i['class_id'], i['slot'], i['department_id'], i['day_of_week']);
      }
    }
  }

  Future<void> b() async {
    timetable1 = await timetableManaging.timetableManaging(semester01And02);
    timetable2 = await timetableManaging.timetableManaging(semester03And04);
    timetable3 = await timetableManaging.timetableManaging(semester05And06);
    timetable4 = await timetableManaging.timetableManaging(semester07And08);
  }

  // saving pdf file of timetable
}
