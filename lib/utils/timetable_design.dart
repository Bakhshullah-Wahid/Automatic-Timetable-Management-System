import 'package:attms/utils/containor.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../responsive.dart';
import 'design_timetable.dart';

class TimetableDesigning extends StatefulWidget {
  final List timetable;
  final List timetable2;
  final List timetable3;
  final List timetable4;
  final String department;
  const TimetableDesigning(
      {super.key,
      required this.timetable,
      required this.timetable2,
      required this.timetable3,
      required this.timetable4,
      required this.department});

  @override
  State<TimetableDesigning> createState() => _TimetableDesigningState();
}

class _TimetableDesigningState extends State<TimetableDesigning> {
  int position = 0;
  @override
  Widget build(BuildContext context) {
    final value = [];
    if (Responsive.isMobile(context)) {
      value.addAll({
        widget.timetable[0]['semester'],
        widget.timetable2[0]['semester'],
        widget.timetable3[0]['semester'],
        widget.timetable4[0]['semester']
      });
    }

    return Responsive.isMobile(context)
        ? Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: value.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              position = index;
                            });
                          },
                          child: Text(
                            value[index],
                            style: TextStyle(
                                color: position == index
                                    ? Colors.orange
                                    : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.black,
                  child: Center(
                    child: Text(value[position],
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.normal)),
                  ),
                ),
                buildMobile(
                    position == 0
                        ? widget.timetable
                        : position == 1
                            ? widget.timetable2
                            : position == 2
                                ? widget.timetable3
                                : widget.timetable4,
                    context,
                    widget.department),
              ],
            ),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '${widget.department}: University of Turbat(Kech)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    widget.timetable[0][0]['semester'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TimetableDesign(
                    timetable: widget.timetable,
                    department: widget.department,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.timetable2[0][0]['semester'],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TimetableDesign(
                    timetable: widget.timetable2,
                    department: widget.department,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.timetable3.isEmpty
                      ? SizedBox.shrink()
                      : Text(
                          widget.timetable3[0][0]['semester'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                  TimetableDesign(
                    timetable: widget.timetable3,
                    department: widget.department,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.timetable4.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          widget.timetable4[0][0]['semester'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                  TimetableDesign(
                    timetable: widget.timetable4,
                    department: widget.department,
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildMobile(List timetable, BuildContext context, department) {
    return Expanded(
      child: GroupedListView<dynamic, String>(
        elements: timetable,
        groupBy: (element) => element['day_of_week'],
        order: GroupedListOrder.ASC,
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                groupByValue,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider(),
            ],
          ),
        ),
        itemBuilder: (context, element) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      element['class_name'].toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                    element['class_department'] == department
                        ? SizedBox.shrink()
                        : Text(
                            ' (${element['class_department'].toString()})',
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.normal),
                          ),
                  ],
                ),
              ),
              TheContainer(
                width: MediaQuery.of(context).size.width * 1 > 300.0
                    ? null
                    : MediaQuery.of(context).size.width * 0.2,
                // Adjust height as needed
                child: ListTile(
                  title: MediaQuery.of(context).size.width * 1 < 300.0
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(element['teacher_name'].toString()),
                            Text(element['slot']),
                          ],
                        ),
                  subtitle: Text(
                    element['subject_name'].toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
