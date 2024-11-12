import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../provider/class_provider.dart';
import '../../../provider/department_provider.dart';
import '../../../route/navigations.dart';
import '../../../services/class/fetch_class_data.dart';
import '../../../wholeData/class/update_class.dart';
import '../../../widget/title_container.dart';

class ClassView extends ConsumerWidget {
  const ClassView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(departmentProvider.notifier).retrieveDepartments();
    ref.read(classProvider.notifier).retrieveClass();
    final department = ref.watch(departmentProvider);
    final classs = ref.watch(classProvider);
    // // Convert departments to a list of maps
    List<Map<String, dynamic>> formattedDepartments = department.map((dept) {
      return {
        'department_name': dept.departmentName,
        'department_id': dept.departmentId,
      };
    }).toList();
    List<Map<String, dynamic>> formattedClass = classs.map((dept) {
      return {
        'class_id': dept.classId,
        'department_id': dept.departmentId,
        'class_name': dept.className,
        'class_type': dept.classType
      };
    }).toList();

    for (var i in formattedDepartments) {
      for (var j in formattedClass) {
        if (i['department_id'] == j['department_id']) {
          j['department_name'] = i['department_name'];
        }
      }
    }

    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const TitleContainer(
            description: "Classes registered for each Department are listed below",
            pageTitle: 'Manage Classes',
            buttonName: 'Add New Class',
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1))),
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
                                    child: Text(
                                      groupByValue,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                              itemBuilder: (context, dynamic element) =>
                                  ListTile(
                                    title: Row(
                                      children: [
                                        SizedBox(
                                          width: mediaquery.width * 0.7,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black
                                                        .withOpacity(0.1))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                element['class_name'] ??
                                                    'No Name',
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              context.go(
                                                Routes.addClass,
                                                extra: UpdateClass(
                                                    classId:
                                                        element['class_id'],
                                                    className:
                                                        element['class_name'],
                                                    classType:
                                                        element['class_type'],
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
                                            final ClassService classsService =
                                                ClassService();
                                            await classsService.deleteClass(
                                                element['class_id']);

                                            // Remove the task from the list
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )))))
        ],
      ),
    ));
  }
}
