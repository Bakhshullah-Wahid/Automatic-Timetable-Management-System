import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../provider/dashboard_provider.dart';
import '../../../responsive.dart';
import '../../../route/navigations.dart';
import '../../../services/coordinator/fetch_user_data.dart';
import '../../../utils/containor.dart';
import '../../../utils/data/fetching_data.dart';
import '../../../wholeData/coordinator/update_user.dart';
import '../../../widget/dialoge_box.dart';
import '../../../widget/manager/manager_drawer.dart';
import '../../../widget/title_container.dart';

class ManagerScreen extends ConsumerWidget {
  ManagerScreen({super.key});
  final FetchingDataCall fetchingDataCall = FetchingDataCall();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formattedDepartments = fetchingDataCall.department(ref);
    var formattedManager = fetchingDataCall.manager(ref);
    for (var i in formattedDepartments) {
      for (var j in formattedManager) {
        if (i['department_id'] == j['department_id']) {
          j['department_name'] = i['department_name'];
        }
      }
    }
    // -----------------------------------------------------

    var mediaquery = MediaQuery.of(context).size;

    final bool mobileCheck = ref.watch(mobileDrawer);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
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
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
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
                                      Padding(
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
                                                        Routes.addAccount,
                                                        extra: UpdateAccount(
                                                            email: element[
                                                                'email'],
                                                            name: element[
                                                                'user_name'],
                                                            password: element[
                                                                'password'],
                                                            userId: element[
                                                                'user_id'],
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
                                                    DialogeBoxOpen deletes =
                                                        DialogeBoxOpen();
                                                    bool isDelete =
                                                        await deletes.deleteBox(
                                                            element[
                                                                'user_name'],
                                                            context);
                                                    if (isDelete) {
                                                      final ManagerService
                                                          taskService =
                                                          ManagerService();
                                                      await taskService
                                                          .deleteManager(
                                                              element[
                                                                  'user_id']);
                                                    }
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                element['user_name'] ??
                                                    'No Name',
                                              ),
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
      ),
    );
  }
}
