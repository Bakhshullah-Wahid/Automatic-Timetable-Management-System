import 'package:attms/utils/data/fetching_data.dart';
import 'package:attms/wholeData/coordinator/update_user.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../responsive.dart';
import '../../../../route/navigations.dart';
import '../../../../services/coordinator/fetch_user_data.dart';
import '../../../../services/email.dart';
import '../../../../widget/manager/department_data.dart';

class AddAccountScreen extends StatefulWidget {
  final UpdateAccount? updatedData;
  const AddAccountScreen({super.key, this.updatedData});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String userType = 'Co-ordinator';
  TextEditingController department = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? departmentType;
  int? userId;
  int? departmentId;
  ManagerService managerUpdate = ManagerService();
  EmailSystem emailing = EmailSystem();
  List<Map<String, dynamic>> dataList = [];
  DepartmentDataForSelectingClassAndCoordinator functionDepartment =
      DepartmentDataForSelectingClassAndCoordinator();

  @override
  void initState() {
    super.initState();
    refJournal();
    setState(() {});
  }

  refJournal() {
    if (widget.updatedData != null) {
      // Ensure updatedClass is not null
      // Check if classId is not null
      if (widget.updatedData!.userId != null) {
        int? departs = widget
            .updatedData!.departmentId; // Get department from updatedClass

        // Check if departmentIdList is not null before iterating

        for (var depart in widget.updatedData!.department) {
          if (depart['department_id'] == departs) {
            department.text = depart['department_name'];
            departmentId = depart['department_id'];
            break;
          }
        }
        userId = widget.updatedData!.userId;
        userName.text = widget.updatedData!.name.toString();
        email.text = widget.updatedData!.email.toString();
        password.text = widget.updatedData!.password.toString();
      }
    }
  }

  FetchingDataCall fetchingDataCall = FetchingDataCall();
  List<Map<String, dynamic>> data = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Consumer(builder: (_, WidgetRef ref, __) {
        var formattedDepartments = fetchingDataCall.department(ref);
        var formattedManager = fetchingDataCall.manager(ref, null);
        for (var i in formattedDepartments) {
          for (var j in formattedManager) {
            if (i['department_id'] == j['department_id']) {
              j['department_name'] = i['department_name'];
            }
          }
        }

        return Form(
            key: formkey,
            child: Column(
              children: [
                const TitleContainer(
                  description: "Add a new Coordinator for a Department",
                  pageTitle: "Add New Coordinator",
                ),
                const SizedBox(
                  height: 100,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
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
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.4,
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
                            controller: userName,
                            cursorHeight: 20,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Co-ordinator name',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 10),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: InputBorder.none,
                              //  OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(12.0),
                              // ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 10),
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: InputBorder.none,

                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(12.0),
                              //   borderSide: const BorderSide(color: Colors.blue),
                              // ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 2),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              } else {
                                return null;
                              }
                            },
                            controller: password,
                            cursorHeight: 20,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                  fontSize: 10, color: Colors.black),
                              hintStyle: const TextStyle(fontSize: 10),
                              prefixIcon: const Icon(Icons.password,
                                  color: Colors.black),
                              prefixStyle: const TextStyle(fontSize: 10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          userId == null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .white, // Background color of the container
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: rounded corners
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                            alpha:
                                                0.2), // Shadow color with opacity
                                        offset:
                                            Offset(0, 10), // Shadow only below
                                        blurRadius:
                                            8, // Controls how blurry the shadow is
                                        spreadRadius:
                                            0.3, // Spread of the shadow
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
                                        List v =
                                            await functionDepartment.function(
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
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Department is required';
                                        } else if (!departmentCheck(
                                            department.text,
                                            formattedManager)) {
                                          return 'Department Coordinator already Exist';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: department,
                                      showCursor: false,
                                      readOnly: true,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: 'Department',
                                        labelStyle: const TextStyle(
                                            fontSize: 10, color: Colors.black),
                                        hintStyle:
                                            const TextStyle(fontSize: 10),
                                        prefixIcon: const Icon(Icons.business,
                                            color: Colors.black),
                                        prefixStyle:
                                            const TextStyle(fontSize: 10),
                                        border: InputBorder.none,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState!.validate() &&
                                email.text.isNotEmpty &&
                                password.text.isNotEmpty &&
                                userName.text.isNotEmpty &&
                                department.text.isNotEmpty) {
                              if (userId == null) {
                                if (departmentCheck(
                                    department.text, formattedManager)) {
                                  managerUpdate.addManager(
                                      userName.text,
                                      'Co-ordinator',
                                      email.text,
                                      password.text,
                                      departmentId!);
                                  context.go(Routes.managerAdmin);
                                }
                              } else {
                                managerUpdate.updateManager(
                                    userId,
                                    userName.text,
                                    'Co-ordinator',
                                    email.text,
                                    password.text,
                                    departmentId!);
                                context.go(Routes.managerAdmin);
                              }
                            }
                          },
                          child: const Text('Done'))
                    ],
                  ),
                ),
              ],
            ));
      }),
    ));
  }

  departmentCheck(department, formattedDepartments) {
    for (var data in formattedDepartments) {
      if (data['department_name'] == department) {
        return false;
      }
    }
    return true;
  }
}
