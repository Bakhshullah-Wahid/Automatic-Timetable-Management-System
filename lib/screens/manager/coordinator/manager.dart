import 'package:attms/provider/manager_provider.dart';
import 'package:attms/services/coordinator/fetch_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../provider/department_provider.dart';
import '../../../route/navigations.dart';
import '../../../wholeData/coordinator/update_user.dart';
import '../../../widget/title_container.dart';

class ManagerScreen extends ConsumerWidget {
  const ManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(departmentProvider.notifier).retrieveDepartments();
    ref.read(managerProvider.notifier).retrieveManager();
    final department = ref.watch(departmentProvider);
    final userss = ref.watch(managerProvider);
    // // Convert departments to a list of maps
    List<Map<String, dynamic>> formattedDepartments = department.map((dept) {
      return {
        'department_name': dept.departmentName,
        'department_id': dept.departmentId,
      };
    }).toList();
    List<Map<String, dynamic>> formattedManager = userss.map((dept) {
      return {
        "user_id": dept.userId,
        "user_name": dept.userName,
        "user_type": dept.userType,
        "email": dept.email,
        "password": dept.password,
        "department_id": dept.departmentId
      };
    }).toList();

    for (var i in formattedDepartments) {
      for (var j in formattedManager) {
        if (i['department_id'] == j['department_id']) {
          j['department_name'] = i['department_name'];
        }
      }
    }
    // -----------------------------------------------------

    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const TitleContainer(
                description:
                    "Coordinators registered for each departments are listed below",
                pageTitle: 'Manage Coordinator',
                buttonName: 'Add New Coordinator',
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: formattedManager.isEmpty
                          ? Center(
                              child: Text(
                              'No Data Found',
                              style: Theme.of(context).textTheme.bodySmall,
                            ))
                          : GroupedListView(
                              elements: formattedManager,
                              groupBy: (element) =>
                                  element['department_name'] ?? '',
                              order: GroupedListOrder.ASC,
                              groupSeparatorBuilder: (String groupByValue) =>
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            groupByValue,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  ),
                              itemBuilder: (context, dynamic element) =>
                                  ListTile(
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
                                                  color: Colors.black.withOpacity(
                                                      0.2), // Shadow color with opacity
                                                  offset: Offset(0,
                                                      10), // Shadow only below
                                                  blurRadius:
                                                      8, // Controls how blurry the shadow is
                                                  spreadRadius:
                                                      0.3, // Spread of the shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                element['user_name'] ??
                                                    'No Name',
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context.go(
                                                Routes.addAccount,
                                                extra: UpdateAccount(
                                                    email: element['email'],
                                                    name: element['user_name'],
                                                    password:
                                                        element['password'],
                                                    userId: element['user_id'],
                                                    departmentId: element[
                                                        'department_id'],
                                                    department:
                                                        formattedDepartments),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            )),
                                        IconButton(
                                          onPressed: () async {
                                            final ManagerService taskService =
                                                ManagerService();
                                            await taskService.deleteManager(
                                                element['user_id']);
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
      ),
    );
  }
}
