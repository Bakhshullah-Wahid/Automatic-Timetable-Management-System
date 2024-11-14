import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/add_new_time_provider.dart';
import '../route/navigations.dart';

class TitleContainer extends StatefulWidget {
  final String? pageTitle;
  final String? description;
  final List? department;
  final List? sems;
  final String? buttonName;
  const TitleContainer(
      {super.key,
      this.department,
      this.pageTitle,
      this.description,
      this.buttonName,
      this.sems});

  @override
  State<TitleContainer> createState() => _TitleContainerState();
}

class _TitleContainerState extends State<TitleContainer> {
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Container(
      height: mediaquery.height * 0.2,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          border: Border.all(color: Colors.black.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.pageTitle}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                widget.pageTitle == 'Manage Classes' ||
                        widget.pageTitle == 'Manage Department' ||
                        widget.pageTitle == 'Manage Coordinator' ||
                        widget.pageTitle == 'Dashboard' ||
                        widget.pageTitle == 'Manage Teacher' ||
                        widget.pageTitle == 'New Timetable'
                    ? Consumer(
                        builder: (context, ref, child) {
                          return TextButton(
                              onPressed: () {
                                if (widget.pageTitle == 'Manage Classes') {
                                  context.push(Routes.addClass);
                                } else if (widget.pageTitle ==
                                    'Manage Coordinator') {
                                  context.push(Routes.addAccount);
                                } else if (widget.pageTitle ==
                                    'Manage Department') {
                                  context.push(Routes.addDepartment);
                                } else if (widget.pageTitle == 'Dashboard') {
                                  context.push(Routes.addNewTime);
                                } else if (widget.pageTitle ==
                                    'Manage Teacher') {
                                  context.push(Routes.addTeacher);
                                } else if (widget.pageTitle ==
                                    'New Timetable') {
                                  ref
                                      .read(addNewTimetableProvider.notifier)
                                      .setPosition(1);
                                  // context.pop();
                                } else {
                                  context.push(Routes.addNewTime);
                                }
                              },
                              child: Text('${widget.buttonName}'));
                        },
                      )
                    : Container()
              ],
            ),
          ),
          const Divider(),
          widget.pageTitle == 'Dashboard'
              ? Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 50),
                        child: Text(
                          'Title',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 90, top: 8.0),
                        child: Text(
                          'Date',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 150),
                        child: Text(
                          'Action',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      )
                    ],
                  ))
              : Container(
                  width: double.maxFinite,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.1)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 50),
                    child: Text(
                      '${widget.description}',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
