import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/add_new_time_provider.dart';
import '../provider/provider_dashboard.dart';
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
      height: mediaquery.height * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5)),
      ),
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
                        widget.pageTitle == 'Class Selection' ||
                        widget.pageTitle == 'Teacher Selection' ||
                        widget.pageTitle == 'Subject Selected' ||
                        widget.pageTitle == 'Manage Subjects' ||
                        widget.pageTitle == 'New Timetable' ||
                        widget.pageTitle == 'Profile'
                    ? Consumer(
                        builder: (context, ref, child) {
                          return TextButton(
                              onPressed: () {
                                if (widget.pageTitle == 'Manage Classes') {
                                  context.push(Routes.addClass);
                                } else if (widget.pageTitle == 'Profile') {
                                  late bool value = ref.watch(isAdmin);
                                  ref
                                      .read(dashboardProvider.notifier)
                                      .setPosition(0);

                                  if (value) {
                                    context.go(Routes.managerAdmin);
                                  } else {
                                    context.go(Routes.home);
                                  }
                                  ref
                                      .read(isLoginProvider.notifier)
                                      .loginTime();
                                } else if (widget.pageTitle ==
                                    'Manage Subjects') {
                                  context.push(Routes.addSubject);
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
                                } else if (widget.pageTitle ==
                                    'Class Selection') {
                                  ref
                                      .read(addNewTimetableProvider.notifier)
                                      .setPosition(2);
                                  // context.pop();
                                } else if (widget.pageTitle ==
                                    'Teacher Selection') {
                                  ref
                                      .read(addNewTimetableProvider.notifier)
                                      .setPosition(3);
                                  // context.pop();
                                } else if (widget.pageTitle ==
                                    'Subject Selected') {
                                  ref
                                      .read(addNewTimetableProvider.notifier)
                                      .setPosition(4);
                                  // context.pop();
                                } else {
                                  context.push(Routes.addNewTime);
                                }
                              },
                              child: Text('${widget.buttonName}',
                                  style: TextStyle(color: Colors.orange)));
                        },
                      )
                    : Container()
              ],
            ),
          ),
          const Divider(),
          widget.pageTitle == 'Dashboard'
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius:
                        BorderRadius.circular(2), // Optional: rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.2), // Shadow color with opacity
                        offset: Offset(0, 1), // Shadow only below
                        blurRadius: 3, // Controls how blurry the shadow is
                        spreadRadius: 0.4, // Spread of the shadow
                      ),
                    ],
                  ),
                  width: double.maxFinite,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 2),
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
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 150),
                            child: Text(
                              'Action',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          )
                        ],
                      )))
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius:
                        BorderRadius.circular(2), // Optional: rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.2), // Shadow color with opacity
                        offset: Offset(0, 1), // Shadow only below
                        blurRadius: 3, // Controls how blurry the shadow is
                        spreadRadius: 0.4, // Spread of the shadow
                      ),
                    ],
                  ),
                  width: double.maxFinite,
                  // width: MediaQuery.of(context).size.width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 50),
                      child: Text(
                        '${widget.description}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
