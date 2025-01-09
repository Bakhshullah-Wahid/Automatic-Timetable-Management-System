import 'package:attms/services/teacher/fetch_teacher.dart';
import 'package:attms/utils/containor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageTeacherRequestPage extends StatefulWidget {
  final List formattedTeacher;
  final String departments;
  final int deptId;
  const ManageTeacherRequestPage(
      {super.key,
      required this.formattedTeacher,
      required this.departments,
      required this.deptId});

  @override
  ManageRequestsPageState createState() => ManageRequestsPageState();
}

class ManageRequestsPageState extends State<ManageTeacherRequestPage> {
  TeacherService c = TeacherService();
  @override
  Widget build(BuildContext context) {
    widget.formattedTeacher.removeWhere(
        (element) => element['department_name'] != widget.departments);
    widget.formattedTeacher
        .removeWhere((element) => element['requested_by'] == '');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: widget.formattedTeacher.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TheContainer(
                      child: ListTile(
                        trailing: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green)),
                            onPressed: () {
                              if (widget.formattedTeacher[index]['given_to'] ==
                                  '') {
                                c.updateTeacher(
                                    widget.formattedTeacher[index]
                                        ['teacher_id'],
                                    widget.formattedTeacher[index]
                                        ['teacher_name'],
                                    widget.formattedTeacher[index]['email'],
                                    widget.formattedTeacher[index]
                                        ['department_id'],
                                    widget.formattedTeacher[index]
                                        ['requested_by'],
                                    widget.formattedTeacher[index]
                                        ['requested_by']);
                                setState(() {});
                              }
                            },
                            child: Text(
                              widget.formattedTeacher[index]['requested_by'] ==
                                      widget.formattedTeacher[index]['given_to']
                                  ? 'Accepted'
                                  : 'Accept',
                              style: TextStyle(color: Colors.white),
                            )),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Request for Teacher'),
                              InkWell(
                                onTap: () {
                                  c.updateTeacher(
                                      widget.formattedTeacher[index]
                                          ['teacher_id'],
                                      widget.formattedTeacher[index]
                                          ['teacher_name'],
                                      widget.formattedTeacher[index]['email'],
                                      widget.formattedTeacher[index]
                                          ['department_id'],
                                      '',
                                      '');

                                  widget.formattedTeacher.removeAt(index);
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        subtitle: Text(
                          'The Teacher "${widget.formattedTeacher[index]['teacher_name']}" is requested by the ${widget.formattedTeacher[index]['requested_by']}',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
