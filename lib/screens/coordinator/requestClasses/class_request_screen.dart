import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../provider/class_provider.dart';
import '../../../../provider/department_provider.dart';
import '../../../services/freeSlots/retrieve_free_slot.dart';
import '../../../services/requestings/requist_ap.dart';

class ClassRequestScreens extends StatefulWidget {
  const ClassRequestScreens({super.key});

  @override
  State<ClassRequestScreens> createState() => _ClassRequestScreensState();
}

class _ClassRequestScreensState extends State<ClassRequestScreens> {
  String departments = '';
  int? deptId;
  journal() async {
    var prefs2 = await SharedPreferences.getInstance();
    var deptPrefs = await SharedPreferences.getInstance();
    deptId = deptPrefs.getInt('deptId');
    departments = prefs2.getString('department').toString();
  }

  @override
  void initState() {
    journal();
    super.initState();
  }

// ====================================================================
  List classes = [];
  List requests = [];
  bool isLoading = true;
  Future<void> sendRequest(
      int classId, int recieveDeptId, int sendDeptId) async {
 await http.post(
      Uri.parse('http://127.0.0.1:8000/request/'),
      body: jsonEncode({
        'requesting_department': sendDeptId,
        'requested_department': recieveDeptId,
        'class_id': classId,
      }),
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<void> fetchData() async {
    try {
      final classResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/classs/'));
      final requestResponse =
          await http.get(Uri.parse('http://127.0.0.1:8000/requests/'));

      if (classResponse.statusCode == 200 &&
          requestResponse.statusCode == 200) {
        setState(() {
          classes = json.decode(classResponse.body);
          requests = json.decode(requestResponse.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load classes or requests');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
    }
  }

  // ===================================================
  final ClassRequestService service = ClassRequestService();
  requestClass(freeSlots, classId, className, departmentName, sendDeptId,
      recieveDeptId) async {
    String checkActivity =
        freeSlots.isEmpty ? '' : freeSlots[0]['request_confirmation'];

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
                                  return element['day'];
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
                  checkActivity == 'SENT'
                      ? TextButton(onPressed: () {}, child: Text('cancel'))
                      : SizedBox.shrink(),
                  freeSlots.isEmpty
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed: () {
                            if (checkActivity == 'REQUEST') {
                              sendRequest(classId, recieveDeptId, sendDeptId);
                            }
                            Navigator.pop(context);
                          },
                          child: Text(checkActivity))
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
              ref.read(departmentProvider.notifier).retrieveDepartments();
              ref.read(classProvider.notifier).retrieveClass();

              final department = ref.watch(departmentProvider);
              final classs = ref.watch(classProvider);
              // // Convert departments to a list of maps

              List<Map<String, dynamic>> formattedDepartments =
                  department.map((dept) {
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
                  // final freeSlots = fetchFreeSlots(j['class_id']);
                }
              }

              formattedClass.removeWhere(
                  (element) => element['department_name'] == departments);
              var mediaquery = MediaQuery.of(context).size;
              return Expanded(
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
                                  ListTile(
                                    onTap: () async {
                                      final freeSlots = await fetchFreeSlots(
                                          element['class_id']);

                                      await requestClass(
                                        freeSlots,
                                        element['class_id'],
                                        element['class_name'],
                                        element['department_name'],
                                        deptId,
                                        element['department_id'],
                                      );
                                    },
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: mediaquery.width * 0.7,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Background color of the container
                                              borderRadius: BorderRadius.circular(
                                                  8), // Optional: rounded corners
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(
                                                      0.2), // Shadow color with opacity
                                                  offset: Offset(0,
                                                      1), // Shadow only below
                                                  blurRadius:
                                                      3, // Controls how blurry the shadow is
                                                  spreadRadius:
                                                      0.4, // Spread of the shadow
                                                ),
                                              ],
                                            ),
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
                                      ],
                                    ),
                                  ))));
            })
          ],
        ),
      ),
    ));
  }
}
