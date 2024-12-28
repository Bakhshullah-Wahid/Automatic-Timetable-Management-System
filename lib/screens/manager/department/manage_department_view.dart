import 'package:attms/provider/department_provider.dart';
import 'package:attms/services/department/fetch_department.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../provider/dashboard_provider.dart';
import '../../../responsive.dart';
import '../../../route/navigations.dart';
import '../../../utils/containor.dart';
import '../../../utils/data/fetching_data.dart';
import '../../../wholeData/department/update_department.dart';
import '../../../widget/dialoge_box.dart';
import '../../../widget/manager/manager_drawer.dart';
import '../../../widget/title_container.dart';

class ManageDepartmentView extends ConsumerWidget {
  ManageDepartmentView({super.key});
  final FetchingDataCall fetchingDataCall = FetchingDataCall();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departments = ref.watch(departmentProvider);
    final bool mobileCheck = ref.watch(mobileDrawer);
    var formattedDepartments = fetchingDataCall.department(ref);
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const TitleContainer(
                  description: "Department registered are listed below",
                  pageTitle: 'Manage Department',
                  buttonName: 'Add New Department',
                ),
                SizedBox(height: 25),
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
                                itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TheContainer(
                                        width: Responsive.isMobile(context)
                                            ? mediaquery.width * 0.5
                                            : mediaquery.width * 0.7,
                                        child: ListTile(
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
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
                                                    await taskService
                                                        .deleteTask(
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
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                formattedDepartments[index]
                                                    ['department_name']),
                                          ),
                                        ),
                                      ),
                                    ))))
              ],
            ),
            mobileCheck ? ManagerDrawerBox() : SizedBox.shrink(),
          ],
        ),
      ),
    ));
  }
}
