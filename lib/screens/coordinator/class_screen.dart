// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:grouped_list/grouped_list.dart';

// import '../route/navigations.dart';
// import '../utils/teacher_vacancy.dart';
// import '../wholeData/coordinator/update_user.dart';
// import '../wholeData/default_data.dart';
// import '../widget/title_container.dart';

// class ClassSelectionScreen extends StatefulWidget { 

//   const ClassSelectionScreen({
//     super.key, 
//   });

//   @override
//   State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
// }

// class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
//   List selectedClass = [];
//   List freeClass = [];
//   List teacherFreeTime = [];
//   List searchedTeacher = [];
//   DefaultData defaultData = DefaultData();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const TitleContainer(
//           pageTitle: 'Class Selection',
//           description:
//               'Your Department classes are already selected if you want another department class for your batches. You can skip the class selection Process if you Dont want other class of Other Department',
//         ),
//         const SizedBox(
//           height: 3,
//         ),
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(5),
//                         bottomRight: Radius.circular(5)),
//                     border: Border.all(color: Colors.black.withOpacity(0.1))),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.8,
//                   child: GroupedListView<dynamic, String>(
//                       elements: defaultData.classesAndDepartments,
//                       groupBy: (element) {
//                         return element['Department'];
//                       },
//                       order: GroupedListOrder.ASC,
//                       groupSeparatorBuilder: (String groupByValue) => Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               groupByValue,
//                               style: Theme.of(context).textTheme.bodyLarge,
//                             ),
//                           ),
//                       itemBuilder: (context, dynamic element) => ListTile(
//                             title: InkWell(
//                               onDoubleTap: () {
//                                 {
//                                   int value = element['classId'];
//                                   bool idExists = selectedClass.any(
//                                       (element) => element['classId'] == value);
//                                   setState(() {
//                                     if (idExists) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               backgroundColor: Colors.red,
//                                               content:
//                                                   Text('Class already added')));
//                                     } else {
//                                       selectedClass.add({
//                                         'Lab': element['Lab'],
//                                         'classId': element['classId'],
//                                         'Department': element['Department'],
//                                         'className': element['className']
//                                       });
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(const SnackBar(
//                                               backgroundColor: Colors.red,
//                                               content: Text('Class added')));
//                                     }
//                                   });
//                                 }
//                               },
//                               child: SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.55,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       '${element['className']}',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .displayLarge,
//                                     ),
//                                   )),
//                             ),
//                           )),
//                 ),
//               ),
//               const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.arrow_forward),
//                   Icon(Icons.arrow_back),
//                 ],
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(5),
//                         bottomRight: Radius.circular(5)),
//                     border: Border.all(color: Colors.black.withOpacity(0.1))),
//                 child: selectedClass.isEmpty
//                     ? const Center(
//                         child: Text('Double click on a class to add',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.normal)),
//                       )
//                     : SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.8,
//                         child: GroupedListView<dynamic, String>(
//                             elements: selectedClass,
//                             groupBy: (element) {
//                               return element['Department'];
//                             },
//                             order: GroupedListOrder.ASC,
//                             groupSeparatorBuilder: (String groupByValue) =>
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     groupByValue,
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                             itemBuilder: (context, dynamic element) => ListTile(
//                                   title: InkWell(
//                                     onDoubleTap: () {
//                                       int value = element['classId'];
//                                       selectedClass.removeWhere((element) =>
//                                           element['classId'] == value);
//                                       setState(() {});
//                                     },
//                                     child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.55,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             '${element['className']}',
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge,
//                                           ),
//                                         )),
//                                   ),
//                                 )),
//                       ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 15.0),
//           child: Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 if (selectedClass.length < 4) {
//                 } else {
//                   bool check = false;

//                   // for (var increment in widget.teacherSubjectData!.teacher) {
//                   //   if (searchedTeacher.isEmpty) {
//                   //     searchedTeacher.add(increment['name']);
//                   //     teacherFreeTime = checkTeacherVacancy(
//                   //         increment['name'], teacherFreeTime);
//                   //     check = true;
//                   //   } else {
//                   //     for (var searchedTeacher in searchedTeacher) {
//                   //       if (increment['name'] == searchedTeacher) {
//                   //         check = true;
//                   //         break;
//                   //       }
//                   //     }
//                   //   }
//                   //   if (check == true) {
//                   //     check = false;
//                   //   } else {
//                   //     searchedTeacher.add(increment['name']);
//                   //     teacherFreeTime = checkTeacherVacancy(
//                   //         increment['name'], teacherFreeTime);
//                   //   }
//                   // }

//                   // teacherFreeTime = calculatingFreeTeacher(
//                   //     teacherFreeTime, widget.teacherSubjectData!.teacher, 0);

// // class booked checking

//                   for (var classIncrement in selectedClass) {
//                     freeClass = checkClassVacancy(
//                       classIncrement['Department'],
//                       classIncrement['className'],
//                       freeClass,
//                     );
//                   }
//                   freeClass =
//                       calculatingFreeTeacher(freeClass, selectedClass, 1);
//                   context.go(Routes.wholeSetup);
//                   print(freeClass);
//                   print(teacherFreeTime);
//                   // context.go(Routes.wholeSetup,
//                   //     extra: ClassTeacherSubjectDataMix(
//                   //         classes: selectedClass,
//                   //         teacher: widget.teacherSubjectData!.teacher,
//                   //         subject: widget.teacherSubjectData!.subject));
//                 }
//               },
//               child: const Text('Next'),
//             ),
//           ),
//         )
//       ],
//     ));
//   }
// }
