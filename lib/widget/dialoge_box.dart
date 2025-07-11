import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';

class DialogeBoxOpen {
  String? selectedSem;
  dialogeBoxOpening(
    name,
    context,
    sems,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(name),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: sems.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 100,
                            height: 50,
                            child: Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromARGB(255, 236, 156, 92),
                                  value: selectedSem == sems[index],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        Navigator.pop(context);
                                        selectedSem = sems[index];
                                      } else {
                                        selectedSem = null;
                                      }
                                    });
                                  },
                                ),
                                Text(sems[index]),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return selectedSem;
  }

  Future<List<dynamic>> teacherSelection(
      name, BuildContext context, teacherList, selectedTeacher) async {
    List w = [];
    w.add(selectedTeacher);
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('Cancel'))
              ],
              title: Text(name),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 200,
                      child: GroupedListView<dynamic, String>(
                        elements: teacherList,
                        groupBy: (element) {
                          return element['department_name'];
                        },
                        order: GroupedListOrder.ASC,
                        groupSeparatorBuilder: (String groupByValue) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            groupByValue,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        itemBuilder: (context, dynamic element) {
                          return ListTile(
                            title: Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor:
                                      const Color.fromARGB(255, 236, 156, 92),
                                  value: selectedTeacher ==
                                      element['teacher_name'],
                                  onChanged: (value) {
                                    setState(() {
                                      if (value!) {
                                        Navigator.pop(context);
                                        w[0] = element['teacher_name'];
                                        w.add(element['teacher_id']);
                                        w.add(element['department_name']);
                                      } else {
                                        w = [];
                                      }
                                    });
                                  },
                                ),
                                Text(element['teacher_name']),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return w;
  }

  deleteBox(
    name,
    context,
  ) async {
    bool hi = false;
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Column(
                  children: [const Text('Delete'), Divider()],
                ),
                content: SizedBox(
                    width: 300,
                    height: 200,
                    child: ListTile(
                      subtitle: Text(
                        '"$name"',
                        style: const TextStyle(color: Colors.black),
                      ),
                      title: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3)),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Do you want to Delete: ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        hi = false;
                        context.pop(context);
                      },
                      child: const Text('cancel')),
                  ElevatedButton(
                      onPressed: () {
                        hi = true;
                        context.pop(context);
                      },
                      child: const Text('Delete'))
                ],
              );
            },
          );
        });
    return hi;
  }
}
