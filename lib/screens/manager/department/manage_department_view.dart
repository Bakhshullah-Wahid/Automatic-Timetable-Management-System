import 'package:attms/provider/department_provider.dart';
import 'package:attms/services/department/fetch_department.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../route/navigations.dart';
import '../../../wholeData/department/update_department.dart';
import '../../../widget/dialoge_box.dart';
import '../../../widget/title_container.dart';

class ManageDepartmentView extends ConsumerWidget {
  const ManageDepartmentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(departmentProvider.notifier).retrieveDepartments();
    final departments = ref.watch(departmentProvider);
    // Convert departments to a list of maps
    List<Map<String, dynamic>> formattedDepartments = departments.map((dept) {
      return {
        'department_name': dept.departmentName,
        'department_id': dept.departmentId,
      };
    }).toList();
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const TitleContainer(
              description: "Department registered are listed below",
              pageTitle: 'Manage Department',
              buttonName: 'Add New Department',
            ),
            const SizedBox(height: 25),
            formattedDepartments.isEmpty
                ? Center(
                    child: Text(
                    'No Data Found',
                    style: Theme.of(context).textTheme.bodySmall,
                  ))
                : Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                            itemCount: formattedDepartments.length,
                            itemBuilder: (context, index) => ListTile(
                                  title: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          width: mediaquery.width * 0.7,
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // Background color of the container
                                            borderRadius: BorderRadius.circular(
                                                8), // Optional: rounded corners
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                    alpha: 0x33), // Shadow color with opacity
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                formattedDepartments[index]
                                                    ['department_name']),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            context.go(
                                              Routes.addDepartment,
                                              extra: UpdateDepartment(
                                                  departmentName:
                                                      departments[index]
                                                          .departmentName,
                                                  departmentId:
                                                      departments[index]
                                                          .departmentId),
                                            );
                                          },
                                          icon: const Icon(Icons.edit,
                                              color: Colors.black)),
                                      IconButton(
                                        onPressed: () async {
                                          DialogeBoxOpen deletes =
                                              DialogeBoxOpen();
                                          bool isDelete =
                                              await deletes.deleteBox(
                                                  departments[index]
                                                      .departmentName,
                                                  context);
                                          if (isDelete) {
                                            final DepartmentService
                                                taskService =
                                                DepartmentService();
                                            await taskService.deleteTask(
                                                departments[index]
                                                    .departmentId);

                                            departments.removeAt(index);
                                          } // Remove the task from the list

                                          //                                   },
                                          //                                 ),
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ))))
          ],
        ),
      ),
    ));
  }
}
