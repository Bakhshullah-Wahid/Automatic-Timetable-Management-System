import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../route/navigations.dart';
import '../../../services/department/fetch_department.dart';
import '../../../wholeData/department/update_department.dart';

class AddDepartmentScreen extends StatefulWidget {
  final UpdateDepartment? updatedDepartment;
  const AddDepartmentScreen({super.key, this.updatedDepartment});

  @override
  State<AddDepartmentScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddDepartmentScreen> {
  TextEditingController departmentName = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? departmentType;
  int? departmentId;

  @override
  void initState() {
    super.initState();
    refJournal();
  }

  refJournal() {
    if (widget.updatedDepartment != null) {
      departmentName.text = widget.updatedDepartment!.departmentName.toString();
      departmentId = widget.updatedDepartment!.departmentId;
    }
  }

  DepartmentService departUpdate = DepartmentService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(builder: (_, WidgetRef ref, __) {
      return Form(
        key: formkey,
        child: Column(
          children: [
            const TitleContainer(
              description: "Add/Update a Department",
              pageTitle: "Add New Department",
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Department name is required';
                  } else {
                    return null;
                  }
                },
                controller: departmentName,
                cursorHeight: 20,
                style: const TextStyle(fontSize: 15, color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Department name',
                  labelStyle:
                      const TextStyle(fontSize: 10, color: Colors.black),
                  hintStyle: const TextStyle(fontSize: 10),
                  prefixIcon: const Icon(Icons.person, color: Colors.black),
                  prefixStyle: const TextStyle(fontSize: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.blue),
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
                      departmentName.text.isNotEmpty) {
                    if (departmentId == null) {
                      
                      departUpdate.addDepartment(departmentName.text);
                    } else {
                     
                      departUpdate.updateDepartment(
                          departmentId, departmentName.text);
                    }
                    context.go(Routes.manageDeparment);
                  }
                },
                child: const Text('Done'))
          ],
        ),
      );
    }));
  }
}
