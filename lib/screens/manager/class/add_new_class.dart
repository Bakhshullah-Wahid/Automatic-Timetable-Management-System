import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../provider/department_provider.dart';
import '../../../route/navigations.dart';
import '../../../services/class/fetch_class_data.dart';
import '../../../wholeData/class/update_class.dart';
import '../../../widget/manager/department_data.dart';

class AddClassScreen extends StatefulWidget {
  final UpdateClass? updatedClass;
  const AddClassScreen({super.key, this.updatedClass});

  @override
  State<AddClassScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddClassScreen> {
  TextEditingController className = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController classType = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  int? departmentId;
  String? departmentType;
  String? classTypes;
  DepartmentDataForSelectingClassAndCoordinator functionDepartment =
      DepartmentDataForSelectingClassAndCoordinator();
  ClassService classUpdate = ClassService();
  int? classId;
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
    if (widget.updatedClass != null) {
      // Ensure updatedClass is not null
      // Check if classId is not null
      if (widget.updatedClass!.classId != null) {
        int? departs =
            widget.updatedClass!.department; // Get department from updatedClass

        // Check if departmentIdList is not null before iterating

        for (var depart in widget.updatedClass!.departmentIdList) {
          if (depart['department_id'] == departs) {
            department.text = depart['department_name'];
            departmentId = depart['department_id'];
            break;
          }
        }

        className.text = widget.updatedClass!.className.toString();
        classType.text = widget.updatedClass!.classType.toString();
        classId = widget.updatedClass!.classId; // Set the classId
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
                description: "Add/Update a new Class for a Department",
                pageTitle: "Add New Class",
              ),
              const SizedBox(
                height: 100,
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
                    controller: className,
                    cursorHeight: 20,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Class name',
                      labelStyle:
                          const TextStyle(fontSize: 10, color: Colors.black),
                      hintStyle: const TextStyle(fontSize: 10),
                      prefixIcon: const Icon(Icons.group, color: Colors.black),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lab is required';
                          } else {
                            return null;
                          }
                        },
                        // onTap: function(yesNo),
                        onTap: () async {
                          String v = await functionDepartment.function(
                              yesNo, 0, context, classType.text);
                          if (v != 'null') {
                            classType.text = v;
                            setState(() {});
                          }
                        },
                        controller: classType,
                        showCursor: false,
                        readOnly: true,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Lab',
                          labelStyle: const TextStyle(
                              fontSize: 10, color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 10),
                          prefixIcon:
                              const Icon(Icons.science, color: Colors.black),
                          prefixStyle: const TextStyle(fontSize: 10),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                ],
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
                        classType.text.isNotEmpty &&
                        className.text.isNotEmpty) {
                      if (classId == null) {
                        classUpdate.addClass(
                            className.text, classType.text, departmentId!);
                      } else {
                        classUpdate.updateClass(classId, className.text,
                            classType.text, departmentId);
                      }
                      context.go(Routes.manageClass);
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
