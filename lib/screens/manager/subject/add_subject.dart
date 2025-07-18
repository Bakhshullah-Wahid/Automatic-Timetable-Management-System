import 'package:attms/services/subject/fetch_subject.dart';
import 'package:attms/utils/data/fetching_data.dart';
import 'package:attms/wholeData/subject/update_subject.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../provider/department_provider.dart'; 
import '../../../responsive.dart';
import '../../../route/navigations.dart';
import '../../../widget/manager/department_data.dart';

class AddSubjectScreen extends StatefulWidget {
  final UpdateSubject? updateSubject;
  const AddSubjectScreen({super.key, this.updateSubject});

  @override
  State<AddSubjectScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddSubjectScreen> {
  TextEditingController subjectName = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController courseModule = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController theory = TextEditingController();
  TextEditingController lab = TextEditingController();
  TextEditingController teacher = TextEditingController();
  TextEditingController semester = TextEditingController();
  int? departmentId;
  String? departmentType;
  String? classTypes;
  int? teacherId;
  DepartmentDataForSelectingClassAndCoordinator functionDepartment =
      DepartmentDataForSelectingClassAndCoordinator();
  SubjectService subjectUpdate = SubjectService();
  int? subjectId;
  List yesNo = ['yes', 'no'];
  List semesterCount = [
    'semester 01',
    'semester 02',
    'semester 03',
    'semester 04',
    'semester 05',
    'semester 06',
    'semester 07',
    'semester 08'
  ];
  List<Map<String, dynamic>> dataList = [];
  final http.Client client = http.Client();
  final List<FetchingDepartment> departments = [];
  @override
  void initState() {
    super.initState();
    // _retrieveDepartment();
    refJournal();
    if (widget.updateSubject?.subjectId == null) {
      theory.text = '0';
      lab.text = '0';
    }

    setState(() {});
  }

  void _increment(String theorys) {
    if (theorys == 'theory') {
      int theorysOne = int.tryParse(theory.text) ?? 0;
      setState(() {
        theory.text = (theorysOne + 1).toString();
      });
    } else {
      int labOne = int.tryParse(lab.text) ?? 0;
      setState(() {
        lab.text = (labOne + 1).toString();
      });
    }
  }

  void _decrement(String theorys) {
    if (theorys == 'theory') {
      int theorysOne = int.tryParse(theory.text) ?? 0;
      if (theorysOne > 0) {
        // Prevent negative values
        setState(() {
          theory.text = (theorysOne - 1).toString();
        });
      }
    } else {
      int labOne = int.tryParse(lab.text) ?? 0;
      if (labOne > 0) {
        // Prevent negative values
        setState(() {
          lab.text = (labOne - 1).toString();
        });
      }
    }
  }

  refJournal() {
    if (widget.updateSubject != null) {
      // Ensure updateSubject is not null
      // Check if subjectId is not null
      if (widget.updateSubject!.subjectId != null) {
        int? departs = widget
            .updateSubject!.department; // Get department from updateSubject
        int? teachersss = widget.updateSubject!.teacher;

        // Check if departmentIdList is not null before iterating

        for (var depart in widget.updateSubject!.departmentIdList) {
          if (depart['department_id'] == departs) {
            department.text = depart['department_name'];
            departmentId = depart['department_id'];
            break;
          }
        }
        for (var teach in widget.updateSubject!.teacherList) {
          if (teach['teacher_id'] == teachersss) {
            teacher.text = teach['teacher_name'];
            teacherId = teach['teacher_id'];
            break;
          }
        }
        semester.text = widget.updateSubject!.semester.toString();
        lab.text = widget.updateSubject!.lab.toString();
        theory.text = widget.updateSubject!.theory.toString();
        subjectName.text = widget.updateSubject!.subjectName.toString();
        courseModule.text = widget.updateSubject!.courseModule.toString();
        subjectId = widget.updateSubject!.subjectId; // Set the subjectId
      }
    }
  }

  FetchingDataCall fetchingDataCall = FetchingDataCall();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Consumer(builder: (_, WidgetRef ref, __) {
          var formattedDepartments = fetchingDataCall.department(ref);
          var formattedTeacher = fetchingDataCall.teacher(ref);
          // // Convert departments to a list of maps

          for (var i in formattedDepartments) {
            for (var j in formattedTeacher) {
              if (i['department_id'] == j['department_id']) {
                j['department_name'] = i['department_name'];
              }
            }
          }
          return Form(
            key: formkey,
            child: Column(children: [
              const TitleContainer(
                description: "Add/Update a new Subject for a Department",
                pageTitle: "Add New Subject",
              ),
              const SizedBox(
                height: 100,
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: 0.2), // Shadow color with opacity
                          offset: Offset(0, 10), // Shadow only below
                          blurRadius: 8, // Controls how blurry the shadow is
                          spreadRadius: 0.3, // Spread of the shadow
                        ),
                      ],
                    ),
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Subject name is required';
                          } else {
                            return null;
                          }
                        },
                        controller: subjectName,
                        cursorHeight: 20,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Subject name',
                          labelStyle: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 10),
                          prefixIcon:
                              const Icon(Icons.menu_book, color: Colors.black),
                          prefixStyle: const TextStyle(fontSize: 10),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: 0.2), // Shadow color with opacity
                          offset: Offset(0, 10), // Shadow only below
                          blurRadius: 8, // Controls how blurry the shadow is
                          spreadRadius: 0.3, // Spread of the shadow
                        ),
                      ],
                    ),
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: TextFormField(
                        onTap: () async {
                          String v = await functionDepartment.function(
                              semesterCount, 0, context, semester.text);
                          if (v != 'null') {
                            semester.text = v;
                            setState(() {});
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Semester is required';
                          } else {
                            return null;
                          }
                        },
                        controller: semester,
                        showCursor: false,
                        readOnly: true,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Semester',
                          labelStyle: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 10),
                          prefixIcon: const Icon(Icons.calendar_today,
                              color: Colors.black),
                          prefixStyle: const TextStyle(fontSize: 10),
                          border: InputBorder.none,
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: 0.1), // Shadow color with opacity
                          offset: Offset(0, 10), // Shadow only below
                          blurRadius: 8, // Controls how blurry the shadow is
                          spreadRadius: 0.3, // Spread of the shadow
                        ),
                      ],
                    ),
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: TextFormField(
                        onTap: () async {
                          List v = await functionDepartment.function(
                              formattedTeacher, 2, context, teacher.text);
                          if (v.isNotEmpty) {
                            teacher.text = v[0];
                            teacherId = v[1];

                            setState(() {});
                          }
                        },
                        controller: teacher,
                        showCursor: false,
                        readOnly: true,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Assign Teacher',
                          labelStyle: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 10),
                          prefixIcon:
                              const Icon(Icons.person, color: Colors.black),
                          prefixStyle: const TextStyle(fontSize: 10),
                          border: InputBorder.none,
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: 0.2), // Shadow color with opacity
                          offset: Offset(0, 10), // Shadow only below
                          blurRadius: 8, // Controls how blurry the shadow is
                          spreadRadius: 0.3, // Spread of the shadow
                        ),
                      ],
                    ),
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Course Module is required';
                          } else {
                            return null;
                          }
                        },
                        // onTap: function(yesNo),

                        controller: courseModule,

                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Course Module',
                          labelStyle: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 10),
                          prefixIcon: const Icon(Icons.library_books,
                              color: Colors.black),
                          prefixStyle: const TextStyle(fontSize: 10),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the container
                      borderRadius:
                          BorderRadius.circular(8), // Optional: rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                              alpha: 0.2), // Shadow color with opacity
                          offset: Offset(0, 10), // Shadow only below
                          blurRadius: 8, // Controls how blurry the shadow is
                          spreadRadius: 0.3, // Spread of the shadow
                        ),
                      ],
                    ),
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.8
                        : MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: TextFormField(
                        onTap: () async {
                          List v = await functionDepartment.function(
                              formattedDepartments,
                              1,
                              context,
                              department.text);
                          if (v.isNotEmpty) {
                            department.text = v[0];
                            departmentId = v[1];

                            setState(() {});
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Department is required';
                          } else {
                            return null;
                          }
                        },
                        controller: department,
                        showCursor: false,
                        readOnly: true,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Department',
                          labelStyle: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 10),
                          prefixIcon:
                              const Icon(Icons.business, color: Colors.black),
                          prefixStyle: const TextStyle(fontSize: 10),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Theory: ',
                          style: TextStyle(color: Colors.black)),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(
                              8), // Optional: rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                  alpha: 0.2), // Shadow color with opacity
                              offset: Offset(0, 10), // Shadow only below
                              blurRadius:
                                  8, // Controls how blurry the shadow is
                              spreadRadius: 0.3, // Spread of the shadow
                            ),
                          ],
                        ),
                        width: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.09
                            : MediaQuery.of(context).size.width * 0.05,
                        child: TextFormField(
                          showCursor: false,
                          readOnly: true,
                          controller: theory,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            suffixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _increment('theory');
                                  },
                                  child: Center(
                                      child: const Icon(Icons.arrow_drop_up,
                                          size: 24)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _decrement('theory');
                                  },
                                  child: const Icon(Icons.arrow_drop_down,
                                      size: 24),
                                ),
                              ],
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (value1) {
                            // Ensure valid numeric input
                            if (int.tryParse(value1) == null) {
                              theory.text = '0';
                            }
                          },
                        ),
                      ),
                      const Text(' + Lab: ',
                          style: TextStyle(color: Colors.black)),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Background color of the container
                          borderRadius: BorderRadius.circular(
                              8), // Optional: rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                  alpha: 0.2), // Shadow color with opacity
                              offset: Offset(0, 10), // Shadow only below
                              blurRadius:
                                  8, // Controls how blurry the shadow is
                              spreadRadius: 0.3, // Spread of the shadow
                            ),
                          ],
                        ),
                        width: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width * 0.09
                            : MediaQuery.of(context).size.width * 0.05,
                        child: TextFormField(
                          showCursor: false,
                          readOnly: true,
                          controller: lab,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none),
                            suffixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _increment('lab');
                                  },
                                  child:
                                      const Icon(Icons.arrow_drop_up, size: 24),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _decrement('lab');
                                  },
                                  child: const Icon(Icons.arrow_drop_down,
                                      size: 24),
                                ),
                              ],
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (value) {
                            // Ensure valid numeric input
                            if (int.tryParse(value) == null) {
                              lab.text = '0';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate() &&
                            department.text.isNotEmpty &&
                            courseModule.text.isNotEmpty &&
                            subjectName.text.isNotEmpty &&
                            semester.text.isNotEmpty &&
                            (int.parse(theory.text) + int.parse(lab.text)) !=
                                0) {
                          if (subjectId == null) {
                            subjectUpdate.addSubject(
                                semester.text,
                                subjectName.text,
                                courseModule.text,
                                teacherId,
                                int.parse(theory.text),
                                int.parse(lab.text),
                                departmentId!);
                          } else {
                            subjectUpdate.updateSubject(
                                semester.text,
                                subjectId,
                                subjectName.text,
                                courseModule.text,
                                departmentId,
                                teacherId,
                                int.parse(lab.text),
                                int.parse(theory.text));
                          }
                          context.go(Routes.manageSubject);
                        }
                      },
                      child: const Text('Done'))
                ],
              )
            ]),
          );
        }),
      ),
    ));
  }
}
