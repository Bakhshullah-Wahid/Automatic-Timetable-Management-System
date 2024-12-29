import 'package:attms/utils/containor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/class/fetch_class_data.dart';

class ManageRequestsPage extends StatefulWidget {
  final List formattedClass;
  final String departments;
  final int deptId;
  const ManageRequestsPage(
      {super.key,
      required this.formattedClass,
      required this.departments,
      required this.deptId});

  @override
  ManageRequestsPageState createState() => ManageRequestsPageState();
}

class ManageRequestsPageState extends State<ManageRequestsPage> {
  ClassService c = ClassService();
  @override
  Widget build(BuildContext context) {
    widget.formattedClass.removeWhere(
        (element) => element['department_name'] != widget.departments);
    widget.formattedClass
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
                  itemCount: widget.formattedClass.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TheContainer(
                      child: ListTile(
                        trailing: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green)),
                            onPressed: () {
                              if (widget.formattedClass[index]['given_to'] ==
                                  '') {
                                c.updateClass(
                                    widget.formattedClass[index]['class_id'],
                                    widget.formattedClass[index]['class_name'],
                                    widget.formattedClass[index]['class_type'],
                                    widget.formattedClass[index]
                                        ['department_id'],
                                    widget.formattedClass[index]
                                        ['requested_by'],
                                    widget.formattedClass[index]
                                        ['requested_by']);
                                setState(() {});
                              }
                            },
                            child: Text(
                              widget.formattedClass[index]['requested_by'] ==
                                      widget.formattedClass[index]['given_to']
                                  ? 'Accepted'
                                  : 'Accept',
                              style: TextStyle(color: Colors.white),
                            )),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Request for Class'),
                              InkWell(
                                onTap: () {
                                  c.updateClass(
                                      widget.formattedClass[index]['class_id'],
                                      widget.formattedClass[index]
                                          ['class_name'],
                                      widget.formattedClass[index]
                                          ['class_type'],
                                      widget.formattedClass[index]
                                          ['department_id'],
                                      '',
                                      '');

                                  widget.formattedClass.removeAt(index);
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
                          'The class "${widget.formattedClass[index]['class_name']}" is requested by the ${widget.formattedClass[index]['requested_by']}',
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
