import 'package:attms/provider/dashboard_provider.dart';
import 'package:attms/utils/data/fetching_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../responsive.dart';
import '../../../route/navigations.dart';
import '../../../services/class/fetch_class_data.dart';
import '../../../utils/containor.dart';
import '../../../wholeData/class/update_class.dart';
import '../../../widget/dialoge_box.dart';
import '../../../widget/manager/manager_drawer.dart';
import '../../../widget/title_container.dart';

class ClassView extends ConsumerWidget {
  ClassView({super.key});

  final FetchingDataCall fetchingDataCall = FetchingDataCall();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formattedDepartments = fetchingDataCall.department(ref);
    var formattedClass = fetchingDataCall.classs(ref);
    for (var i in formattedDepartments) {
      for (var j in formattedClass) {
        if (i['department_id'] == j['department_id']) {
          j['department_name'] = i['department_name'];
        }
      }
    }
    final bool mobileCheck = ref.watch(mobileDrawer);
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
                  description:
                      "Classes registered for each Department are listed below",
                  pageTitle: 'Manage Classes',
                  buttonName: 'Add New Class',
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: formattedClass.isEmpty
                            ? Center(
                                child: Text(
                                'No Class Found',
                                style: Theme.of(context).textTheme.bodySmall,
                              ))
                            : GroupedListView(
                                elements: formattedClass,
                                groupBy: (element) =>
                                    element['department_name'] ?? '',
                                order: GroupedListOrder.ASC,
                                groupSeparatorBuilder: (String groupByValue) =>
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
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
                                                      Routes.addClass,
                                                      extra: UpdateClass(
                                                          classId: element[
                                                              'class_id'],
                                                          className: element[
                                                              'class_name'],
                                                          classType: element[
                                                              'class_type'],
                                                          department: element[
                                                              'department_id'],
                                                          departmentIdList:
                                                              formattedDepartments),
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
                                                          element['class_name'],
                                                          context);
                                                  if (isDelete) {
                                                    final ClassService
                                                        classsService =
                                                        ClassService();
                                                    await classsService
                                                        .deleteClass(element[
                                                            'class_id']);
                                                  }
                                                  // final ClassService classsService =
                                                  //     ClassService();
                                                  // await classsService
                                                  //     .deleteClass(element['class_id']);

                                                  // Remove the task from the list
                                                },
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              element['class_name'] ??
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
    ));
  }
}
