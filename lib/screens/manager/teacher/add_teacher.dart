import 'package:attms/services/teacher/fetch_teacher.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../provider/department_provider.dart';
import '../../../route/navigations.dart';
import '../../../wholeData/teacher/update_teacher.dart';
import '../../../widget/manager/department_data.dart';

class AddTeacherScreen extends StatefulWidget {
  final UpdateTeacher? updateTeacher;
  const AddTeacherScreen({super.key, this.updateTeacher});

  @override
  State<AddTeacherScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddTeacherScreen> {
  TextEditingController teacherName = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  int? departmentId;
  String? departmentType;
  String? classTypes;
  DepartmentDataForSelectingClassAndCoordinator functionDepartment =
      DepartmentDataForSelectingClassAndCoordinator();
  TeacherService teacherUpdate = TeacherService();
  int? teacherId;
  List yesNo = ['yes', 'no'];
  List<Map<String, dynamic>> dataList = [];
  final http.Client client = http.Client();
  final List<FetchingDepartment> departments = [];
  @override
  void initState() {
    super.initState();
    // _retrieveDepartment();
    refJournal();
    setState(() {});
  }

  refJournal() {
    if (widget.updateTeacher != null) {
      // Ensure updateTeacher is not null
      // Check if teacherId is not null
      if (widget.updateTeacher!.teacherId != null) {
        int? departs = widget
            .updateTeacher!.department; // Get department from updateTeacher

        // Check if departmentIdList is not null before iterating

        for (var depart in widget.updateTeacher!.departmentIdList) {
          if (depart['department_id'] == departs) {
            department.text = depart['department_name'];
            departmentId = depart['department_id'];
            break;
          }
        }

        teacherName.text = widget.updateTeacher!.teacherName.toString();
        email.text = widget.updateTeacher!.email.toString();
        teacherId = widget.updateTeacher!.teacherId; // Set the teacherId
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Consumer(builder: (_, WidgetRef ref, __) {
        ref.read(departmentProvider.notifier).retrieveDepartments();
        final departments = ref.watch(departmentProvider);
        // Convert departments to a list of maps
        List<Map<String, dynamic>> formattedDepartments =
            departments.map((dept) {
          return {
            'department_name': dept.departmentName,
            'department_id': dept.departmentId,
          };
        }).toList();

        return Form(
          key: formkey,
          child: Column(
            children: [
              const TitleContainer(
                description: "Add/Update a Teacher for a Department",
                pageTitle: "Add New Teacher",
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      offset: Offset(0, 10), // Shadow only below
                      blurRadius: 8, // Controls how blurry the shadow is
                      spreadRadius: 0.3, // Spread of the shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Class name is required';
                      } else {
                        return null;
                      }
                    },
                    controller: teacherName,
                    cursorHeight: 20,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Class name',
                      labelStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      hintStyle: const TextStyle(fontSize: 10),
                      prefixIcon: const Icon(Icons.person, color: Colors.black),
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
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      offset: Offset(0, 10), // Shadow only below
                      blurRadius: 8, // Controls how blurry the shadow is
                      spreadRadius: 0.3, // Spread of the shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    cursorHeight: 20,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      hintStyle: const TextStyle(fontSize: 10),
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
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
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      offset: Offset(0, 10), // Shadow only below
                      blurRadius: 8, // Controls how blurry the shadow is
                      spreadRadius: 0.3, // Spread of the shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                  child: TextFormField(
                    onTap: () async {
                      List v = await functionDepartment.function(
                          formattedDepartments, 1, context, department.text);
                      if (v != 'null') {
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
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Department',
                      labelStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState!.validate() &&
                        department.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        teacherName.text.isNotEmpty) {
                      if (teacherId == null) {
                        teacherUpdate.addTeacher(
                            teacherName.text, email.text, departmentId!);
                      } else {
                        teacherUpdate.updateTeacher(teacherId, teacherName.text,
                            email.text, departmentId);
                      }
                      context.go(Routes.teacherView);
                    }
                  },
                  child: const Text('Done'))
            ],
          ),
        );
      }),
    ));
  }
}
