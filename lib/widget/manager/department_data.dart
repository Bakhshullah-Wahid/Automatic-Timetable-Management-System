import 'package:flutter/material.dart';

class DepartmentDataForSelectingClassAndCoordinator {
  function(dataUse, choiceValue, context, working) async {
    String? classTypes;
    String? dummyClass;
    List departmentType = [];
    String? dummyDepart;
    int? departmentId;

    if (working != null) {
      if (choiceValue == 0) {
        dummyClass = working;
      } else {
        dummyDepart = working;
      }
    }
    await showDialog(
        context: context,
        builder: (
          context,
        ) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Choice',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 200,
                      child: dataUse.length < 1
                          ? Center(
                              child: Text(
                                'Add a department First',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataUse.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: const Color.fromARGB(
                                            255, 236, 156, 92),
                                        value: choiceValue == 0
                                            ? dummyClass == dataUse[index]
                                            : choiceValue == 1
                                                ? dummyDepart ==
                                                    dataUse[index]
                                                        ['department_name']
                                                : dummyDepart ==
                                                    dataUse[index]
                                                        ['teacher_name'],
                                        onChanged: (value) {
                                          if (value!) {
                                            if (choiceValue == 0) {
                                              dummyClass = dataUse[index];
                                            } else if (choiceValue == 1) {
                                              dummyDepart = dataUse[index]
                                                  ['department_name'];
                                              departmentId = dataUse[index]
                                                  ['department_id'];
                                            } else {
                                              dummyDepart = dataUse[index]
                                                  ['teacher_name'];
                                              departmentId =
                                                  dataUse[index]['teacher_id'];
                                            }
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      Text(choiceValue == 0
                                          ? dataUse[index]
                                          : choiceValue == 1
                                              ? dataUse[index]
                                                  ['department_name']
                                              : dataUse[index]['teacher_name']),
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
                    Navigator.of(context).pop();
                    setState(() {
                      if (choiceValue == 0) {
                        if (dummyClass != null) {
                          classTypes = dummyClass;
                        }
                      } else {
                        if (dummyDepart != null) {
                          departmentType = [];
                          departmentType.add(dummyDepart);
                          departmentType.add(departmentId);
                        }
                      }
                    });
                  },
                  child: const Text('Select',
                      style: TextStyle(
                        color: Color.fromARGB(255, 91, 158, 125),
                      )),
                ),
              ],
            ),
          );
        });
    if (choiceValue == 0) {
      return classTypes.toString();
    } else {
      return departmentType;
    }
  }
}
