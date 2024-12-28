import 'package:attms/provider/class_provider.dart';
import 'package:attms/provider/retrieve_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/department_provider.dart';

class ManageRequestsPage extends StatefulWidget {
  const ManageRequestsPage({super.key});

  @override
  ManageRequestsPageState createState() => ManageRequestsPageState();
}

class ManageRequestsPageState extends State<ManageRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                ref.read(departmentProvider.notifier).retrieveDepartments();
                ref.read(classProvider.notifier).retrieveClass();
                ref.read(requestProvider.notifier).retrieveRequest();
                // final department = ref.watch(departmentProvider);
                // final classs = ref.watch(classProvider);
                // final requestsAction = ref.watch(requestProvider);
                // // Convert departments to a list of maps
                // List<Map<String, dynamic>> formattedDepartments =
                //     department.map((dept) {
                //   return {
                //     'department_name': dept.departmentName,
                //     'department_id': dept.departmentId,
                //   };
                // }).toList();
                // List<Map<String, dynamic>> formattedRequest =
                //     requestsAction.map((dept) {
                //   return {
                //     'id': dept.id,
                //     'status': dept.status,
                //     'department_id': dept.requesterDepartment,
                //     'class_id': dept.requestedClass,
                //     'date_created': dept.dateCreated,
                //     'purpose': dept.purpose,
                //   };
                // }).toList();
                // List<Map<String, dynamic>> formattedClass = classs.map((dept) {
                //   return {
                //     'class_id': dept.classId,
                //     'department_id': dept.departmentId,
                //     'class_name': dept.className,
                //     'class_type': dept.classType
                //   };
                // }).toList();

                return Expanded(child: Text('hello'));
              },
            )
          ],
        ),
      ),
    );
  }
}
