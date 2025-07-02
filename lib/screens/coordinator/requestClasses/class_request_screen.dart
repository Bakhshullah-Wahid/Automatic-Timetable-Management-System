import 'package:attms/services/class/fetch_class_data.dart';
import 'package:attms/utils/containor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../services/freeSlots/retrieve_free_slot.dart';
import '../../../services/requestings/requist_ap.dart';

class ClassRequestScreens extends StatefulWidget {
  final String departments;
  final int deptId;
  final List formattedClass;
  final WidgetRef ref;
  const ClassRequestScreens(
      {super.key,
      required this.ref,
      required this.formattedClass,
      required this.departments,
      required this.deptId});

  @override
  State<ClassRequestScreens> createState() => _ClassRequestScreensState();
}

class _ClassRequestScreensState extends State<ClassRequestScreens> {
// ====================================================================
  List classes = [];
  List requests = [];
  bool isLoading = true;
  // ===================================================
  final ClassRequestService service = ClassRequestService();
  ClassService c = ClassService();
  requestClass(freeSlots, classId, className, departmentName, requestedBy,
      departmentId, classType) async {
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(className),
                content: freeSlots.isEmpty
                    ? Text('Slots are Booked')
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 300,
                              height: 200,
                              child: GroupedListView<dynamic, String>(
                                elements: freeSlots,
                                groupBy: (element) {
                                  return element['day_of_week'];
                                },
                                order: GroupedListOrder.ASC,
                                groupSeparatorBuilder: (String groupByValue) =>
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    groupByValue,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                itemBuilder: (context, dynamic element) {
                                  return ListTile(
                                    title: Row(
                                      children: [
                                        Text(element['free_slots']),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('cancel')),
                  freeSlots.isEmpty
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed: () async {
                            if (requestedBy == widget.departments) {
                              await c.updateClass(classId, className, classType,
                                  departmentId, '', '');
                            } else {
                              await c.updateClass(classId, className, classType,
                                  departmentId, widget.departments, '');
                            }
                            Navigator.pop(context);
                          },
                          child: Text(requestedBy == widget.departments
                              ? 'Cancel Request'
                              : 'Request'))
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Consumer(builder: (context, ref, child) {
              widget.formattedClass.removeWhere((element) =>
                  element['department_name'] == widget.departments); 
              return Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: widget.formattedClass.isEmpty
                          ? Center(
                              child: Text(
                              'No Class Found',
                              style: Theme.of(context).textTheme.bodySmall,
                            ))
                          : GroupedListView(
                              elements: widget.formattedClass,
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TheContainer(
                                      child: ListTile(
                                        subtitle: element['requested_by'] !=
                                                    '' &&
                                                element['requested_by'] !=
                                                    widget.departments
                                            ? Text(
                                                'This class is requested by: ${element['requested_by']}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 10),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  element['requested_by'] ==
                                                              '' ||
                                                          element['requested_by'] ==
                                                              widget.departments
                                                      ? TextButton(
                                                          onPressed: () async {
                                                            final container =
                                                                ProviderContainer();
                                                            final freeSlots =
                                                                await fetchFreeSlots(
                                                                    element[
                                                                        'class_id'],
                                                                    container);

                                                            await requestClass(
                                                                freeSlots,
                                                                element[
                                                                    'class_id'],
                                                                element[
                                                                    'class_name'],
                                                                element[
                                                                    'department_name'],
                                                                element[
                                                                    'requested_by'],
                                                                element[
                                                                    'department_id'],
                                                                element[
                                                                    'class_type']);
                                                          },
                                                          child:
                                                              Text('view slot'))
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                        title: Row(
                                          children: [
                                            Text(
                                              element['class_name'] ??
                                                  'No Name',
                                            ),
                                            element['requested_by'] ==
                                                    widget.departments
                                                ? element['given_to'] ==
                                                        widget.departments
                                                    ? Text(
                                                        'Request Accepted',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 8),
                                                      )
                                                    : Text(
                                                        'Request sent',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 8),
                                                      )
                                                : SizedBox.shrink()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))));
            })
          ],
        ),
      ),
    ));
  }
}
