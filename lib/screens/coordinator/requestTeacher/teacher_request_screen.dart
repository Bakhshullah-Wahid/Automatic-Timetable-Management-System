import 'package:attms/services/teacher/fetch_teacher.dart';
import 'package:attms/utils/containor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../services/requestings/requist_ap.dart';

class TeacherRequestScreens extends StatefulWidget {
  final String departments;
  final int deptId;
  final List formattedTeacher;
  const TeacherRequestScreens(
      {super.key,
      required this.formattedTeacher,
      required this.departments,
      required this.deptId});

  @override
  State<TeacherRequestScreens> createState() => _ClassRequestScreensState();
}

class _ClassRequestScreensState extends State<TeacherRequestScreens> {
// ====================================================================
  List teachers = [];
  List requests = [];
  bool isLoading = true;
  // ===================================================
  final ClassRequestService service = ClassRequestService();
  TeacherService c = TeacherService();

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
              widget.formattedTeacher.removeWhere((element) =>
                  element['department_name'] == widget.departments);
              return Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: widget.formattedTeacher.isEmpty
                          ? Center(
                              child: Text(
                              'No Teacher Found',
                              style: Theme.of(context).textTheme.bodySmall,
                            ))
                          : GroupedListView(
                              elements: widget.formattedTeacher,
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
                                        subtitle: (element['requested_by'] !=
                                                    '' &&
                                                element['requested_by'] !=
                                                    widget.departments)
                                            ? Text(
                                                'This Teacher is requested by: ${element['requested_by']}',
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
                                                            if (element[
                                                                    'requested_by'] ==
                                                                widget
                                                                    .departments) {
                                                              await c.updateTeacher(
                                                                  element[
                                                                      'teacher_id'],
                                                                  element[
                                                                      'teacher_name'],
                                                                  element[
                                                                      'email'],
                                                                  element[
                                                                      'department_id'],
                                                                  '',
                                                                  '');
                                                            } else {
                                                              await c.updateTeacher(
                                                                  element[
                                                                      'teacher_id'],
                                                                  element[
                                                                      'teacher_name'],
                                                                  element[
                                                                      'email'],
                                                                  element[
                                                                      'department_id'],
                                                                  widget
                                                                      .departments,
                                                                  '');
                                                            }
                                                          },
                                                          child: Text(element[
                                                                      'requested_by'] ==
                                                                  widget
                                                                      .departments
                                                              ? 'Cancel request'
                                                              : 'Request'))
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                        title: Row(
                                          children: [
                                            Text(
                                              element['teacher_name'] ??
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
