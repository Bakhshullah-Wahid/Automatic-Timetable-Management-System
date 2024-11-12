// import 'package:attms/widget/title_container.dart';
// import 'package:flutter/material.dart';
 

// class SemestersTiming extends StatefulWidget {

//   const SemestersTiming({
//     super.key,
  
//   });

//   @override
//   State<SemestersTiming> createState() => _SemestersTimingState();
// }

// class _SemestersTimingState extends State<SemestersTiming> {
//   List<Color> dayColors =
//       List.generate(6, (index) => const Color.fromARGB(255, 229, 229, 229));
//   List _selectedItems = [];
//   List semester1and2 = [];
//   List semester3and4 = [];
//   List semester5and6 = [];
//   List semester7and8 = [];

//   dayselection(listSelection) async {
//     await showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Days'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       width: 300,
//                       height: 200,
//                       child: ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         addRepaintBoundaries: true,
//                         shrinkWrap: true,
//                         itemCount: 6,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (index == 0) {
//                                   if (_selectedItems.isEmpty) {
//                                     _selectedItems = [
//                                       'Monday',
//                                       'Tuesday',
//                                       'Wednesday',
//                                       'Thursday',
//                                       'Friday',
//                                     ];

//                                     for (int i = 0; i < 6; i++) {
//                                       dayColors[i] = dayColors[i] ==
//                                               const Color.fromRGBO(
//                                                   229, 229, 229, 1)
//                                           ? const Color(0xFF0161CD)
//                                           : const Color.fromARGB(
//                                               255, 229, 229, 229);
//                                     }
//                                   } else {
//                                     if (_selectedItems.isNotEmpty &&
//                                         _selectedItems.length < 6) {
//                                       dayColors[0] = const Color(0xFF0161CD);
//                                       for (int i = 0; i < 6; i++) {
//                                         dayColors[i] = const Color.fromARGB(
//                                             255, 229, 229, 229);
//                                       }
//                                       _selectedItems.clear();
//                                       _selectedItems = [
//                                         'Monday',
//                                         'Tuesday',
//                                         'Wednesday',
//                                         'Thursday',
//                                         'Friday',
//                                       ];
//                                       for (int i = 0; i < 6; i++) {
//                                         dayColors[i] = dayColors[i] ==
//                                                 const Color.fromARGB(
//                                                     255, 229, 229, 229)
//                                             ? const Color(0xFF0161CD)
//                                             : const Color.fromARGB(
//                                                 255, 229, 229, 229);
//                                       }
//                                       dayColors[0] = const Color(0xFF0161CD);
//                                     } else {
//                                       for (int i = 0; i < 6; i++) {
//                                         dayColors[i] = dayColors[i] =
//                                             const Color.fromARGB(
//                                                 255, 229, 229, 229);
//                                       }

//                                       _selectedItems.clear();
//                                     }
//                                   }
//                                 } else {
//                                   if (_selectedItems.contains([
//                                     'All',
//                                     'Monday',
//                                     'Tuesday',
//                                     'Wednesday',
//                                     'Thursday',
//                                     'Friday',
//                                   ][index])) {
//                                     _selectedItems.remove([
//                                       'All',
//                                       'Monday',
//                                       'Tuesday',
//                                       'Wednesday',
//                                       'Thursday',
//                                       'Friday',
//                                     ][index]);
//                                   } else {
//                                     _selectedItems.add([
//                                       'All',
//                                       'Monday',
//                                       'Tuesday',
//                                       'Wednesday',
//                                       'Thursday',
//                                       'Friday',
//                                     ][index]);
//                                   }
//                                   dayColors[0] =
//                                       const Color.fromARGB(255, 229, 229, 229);
//                                   if (_selectedItems.length == 5) {
//                                     dayColors[0] = const Color(0xFF0161CD);
//                                   }

//                                   dayColors[index] = dayColors[index] ==
//                                           const Color.fromARGB(
//                                               255, 229, 229, 229)
//                                       ? const Color(0xFF0161CD)
//                                       : const Color.fromARGB(
//                                           255, 229, 229, 229);
//                                 }
//                               });
//                             },
//                             child: Container(
//                               width: 40.0,
//                               height: 40.0,
//                               margin: const EdgeInsets.all(8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(10)),
//                                 color: dayColors[index],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   [
//                                     'All',
//                                     'Mon',
//                                     'Tue',
//                                     'Wed',
//                                     'Thu',
//                                     'Fri',
//                                   ][index],
//                                   style: TextStyle(
//                                       color: dayColors[index] ==
//                                               const Color.fromARGB(
//                                                   255, 229, 229, 229)
//                                           ? Colors.black
//                                           : const Color.fromARGB(
//                                               255, 229, 229, 229)),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     ElevatedButton(
//                         onPressed: () {
//                           if (listSelection == 0) {
//                             semester1and2 = [];
//                             semester1and2 = _selectedItems;
//                           } else if (listSelection == 1) {
//                             semester3and4 = [];
//                             semester3and4 = _selectedItems;
//                           } else if (listSelection == 2) {
//                             semester5and6 = [];
//                             semester5and6 = _selectedItems;
//                           } else if (listSelection == 3) {
//                             semester7and8 = [];
//                             semester7and8 = _selectedItems;
//                           }
//                           dayColors = List.generate(
//                               6,
//                               (index) =>
//                                   const Color.fromARGB(255, 229, 229, 229));
//                           _selectedItems = [];
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Done'))
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // here
//   List timingClasses = ['9:15', '9:30'];
//   String selectTimings = '';
//   // to here
//   selectTiming() async {
//     await showDialog(
//       barrierDismissible: true,
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Classes Starts'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       width: 300,
//                       height: 200,
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: timingClasses.length,
//                         itemBuilder: (context, index) {
//                           return SizedBox(
//                             width: 100,
//                             height: 50,
//                             child: Row(
//                               children: [
//                                 Checkbox(
//                                   checkColor: Colors.white,
//                                   activeColor:
//                                       const Color.fromARGB(255, 236, 156, 92),
//                                   value: selectTimings == timingClasses[index],
//                                   onChanged: (value) {
//                                     setState(() {
//                                       if (value!) {
//                                         selectTimings = timingClasses[index];

//                                         Navigator.pop(context);
//                                       } else {
//                                         selectTimings = '';
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 Text(timingClasses[index])
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   bool choiceOfTimings = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const TitleContainer(
//             description: 'Time/Week for each departments are to be selected',
//             pageTitle: 'Select Time/Week',
//           ),
//           Row(
//             children: [
//               Text(
//                 'Do you want to keep all semesters timetable time and day same?',
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//               Switch(
//                   value: choiceOfTimings,
//                   onChanged: (value) {
//                     setState(() {
//                       choiceOfTimings = !choiceOfTimings;
//                     });
//                   }),
//             ],
//           ),
//           choiceOfTimings
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 50.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'All Semester Selected',
//                         style: Theme.of(context).textTheme.displaySmall,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       ElevatedButton(
//                           onPressed: () async {
//                             await selectTiming();
//                           },
//                           child: selectTimings == ''
//                               ? const Row(
//                                   children: [
//                                     Text('Select Time'),
//                                     Icon(Icons.arrow_drop_down)
//                                   ],
//                                 )
//                               : Text(selectTimings)),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         'and',
//                         style: Theme.of(context).textTheme.displaySmall,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       ElevatedButton(
//                           onPressed: () async {
//                             await dayselection(0);
//                             setState(() {});
//                           },
//                           child: Text(
//                               semester1and2.isEmpty ? 'Days' : 'selected')),
//                     ],
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.only(top: 50.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'All Semesters Start Time',
//                             style: Theme.of(context).textTheme.displaySmall,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 await selectTiming();
//                                 setState(() {});
//                               },
//                               child: selectTimings == ''
//                                   ? const Row(
//                                       children: [
//                                         Text('Select Time'),
//                                         Icon(Icons.arrow_drop_down)
//                                       ],
//                                     )
//                                   : Text(selectTimings)),
//                         ],
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Semester 1/2',
//                             style: Theme.of(context).textTheme.displaySmall,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 await dayselection(0);

//                                 setState(() {});
//                               },
//                               child: Text(
//                                   semester1and2.isEmpty ? 'Days' : 'selected')),
//                         ],
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Semester 3/4',
//                             style: Theme.of(context).textTheme.displaySmall,
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 await dayselection(1);

//                                 setState(() {});
//                               },
//                               child: Text(
//                                   semester3and4.isEmpty ? 'Days' : 'selected')),
//                         ],
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Semester 5/6',
//                             style: Theme.of(context).textTheme.displaySmall,
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 await dayselection(2);

//                                 setState(() {});
//                               },
//                               child: Text(
//                                   semester5and6.isEmpty ? 'Days' : 'selected')),
//                         ],
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Semester 7/8',
//                             style: Theme.of(context).textTheme.displaySmall,
//                           ),
//                           const SizedBox(
//                             width: 15,
//                           ),
//                           ElevatedButton(
//                               onPressed: () async {
//                                 await dayselection(3);

//                                 setState(() {});
//                               },
//                               child: Text(
//                                   semester7and8.isEmpty ? 'Days' : 'selected')),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//           Padding(
//             padding: const EdgeInsets.only(top: 40.0),
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   // context.go(Routes.wholeSetup , extra: ClassTeacherSubjectDataMix(classes: freeClass, teacher: teacherFreeTime, subject: widget.classTeacherSubjectData!.subject));
//                   // if (choiceOfTimings == true) {
//                   //   timetableGenerationCode(
//                   //       teacherFreeTime,
//                   //       freeClass,
//                   //       widget.classTeacherSubjectData!.teacher,
//                   //       widget.classTeacherSubjectData!.classes);
//                   // } else {}
//                 },
//                 child: const Text('Generate Timetable'),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
