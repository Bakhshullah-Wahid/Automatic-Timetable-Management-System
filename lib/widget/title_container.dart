import 'package:attms/provider/dashboard_provider.dart';
import 'package:attms/provider/retrieve_free_slots_pro.dart';
import 'package:attms/provider/subject_provider.dart';
import 'package:attms/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/add_new_time_provider.dart';
import '../provider/class_provider.dart';
import '../provider/provider_dashboard.dart';
import '../provider/teacher_provider.dart';
import '../provider/timetable_provider.dart';
import '../route/navigations.dart';
import '../utils/containor.dart';

class TitleContainer extends StatefulWidget {
  final String? pageTitle;
  final String? description;
  final List? department;
  final List? sems;
  final String? buttonName;
  final Function? timetableItself;
  const TitleContainer(
      {super.key,
      this.department,
      this.pageTitle,
      this.description,
      this.buttonName,
      this.sems,
      this.timetableItself});

  @override
  State<TitleContainer> createState() => _TitleContainerState();
}

class _TitleContainerState extends State<TitleContainer> {
  @override
  Widget build(BuildContext context) {
    // var mediaquery = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      return Container(
        // height: mediaquery.height * 0.1,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      '${widget.pageTitle}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                widget.pageTitle == 'Manage Classes' ||
                        widget.pageTitle == 'Manage Department' ||
                        widget.pageTitle == 'Generate Timetable' ||
                        widget.pageTitle == 'Manage Coordinator' ||
                        widget.pageTitle == 'Dashboard' ||
                        widget.pageTitle == 'Manage Teacher' ||
                        widget.pageTitle == 'Class Selection' ||
                        widget.pageTitle == 'Teacher Selection' ||
                        widget.pageTitle == 'Subject Selected' ||
                        widget.pageTitle == 'Manage Subjects' ||
                        widget.pageTitle == 'Manage subjects' ||
                        widget.pageTitle == 'New Timetable' ||
                        widget.pageTitle == 'Request For Classes' ||
                        widget.pageTitle == 'Profile' ||
                        widget.pageTitle == 'Dashboard ' ||
                        widget.pageTitle == 'About Us'
                    ? (Responsive.isMobile(context))
                        ? widget.pageTitle == 'New Timetable' ||
                                widget.pageTitle == 'Teacher Selection' ||
                                widget.pageTitle == 'Class Selection' ||
                                widget.pageTitle == 'Subject Selected' ||
                                widget.pageTitle == 'Generate Timetable'
                            ? SizedBox.shrink()
                            : IconButton(
                                onPressed: () {
                                  ref
                                      .read(mobileDrawer.notifier)
                                      .setPositionMobile();
                                },
                                icon: Icon(Icons.list))
                        : widget.buttonName == null
                            ? SizedBox.shrink()
                            : button()
                    : SizedBox.shrink()
              ],
            ),
            const Divider(),
            TheContainer(
              width: double.maxFinite,
              // width: MediaQuery.of(context).size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 50),
                child: Text(
                  '${widget.description}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
            if (Responsive.isMobile(context))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [if (widget.buttonName != null) button()],
              )
          ],
        ),
      );
    });
  }

  Widget button() {
    return SizedBox(
      child: Consumer(
        builder: (context, ref, child) {
          return TextButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                var prefs2 = await SharedPreferences.getInstance();
                if (widget.pageTitle == 'Manage Classes') {
                  context.push(Routes.addClass);
                } else if (widget.pageTitle == 'Profile') {
                  late bool value = ref.watch(isAdmin);
                  ref.read(dashboardProvider.notifier).setPosition(0);
                  prefs2.setString('department', '');

                  prefs.setInt('deptId', -1);
                  ref.invalidate(timetableProvider);
                  if (value) {
                    context.go(Routes.managerAdmin);
                  } else {
                    context.go(Routes.home);
                  }
                  ref.read(isLoginProvider.notifier).loginTime(); // restart();
                } else if (widget.pageTitle == 'Manage Subjects') {
                  dis(ref);
                  context.push(Routes.addSubject);
                } else if (widget.pageTitle == 'Manage Coordinator') {
                  dis(ref);
                  context.push(Routes.addAccount);
                } else if (widget.pageTitle == 'Manage Department') {
                  dis(ref);
                  context.push(Routes.addDepartment);
                } else if (widget.pageTitle == 'Dashboard') {
                  dis(ref);
                  context.push(Routes.addNewTime);
                } else if (widget.pageTitle == 'Dashboard ') {
                  ref.invalidate(timetableProvider);
                  await widget.timetableItself?.call();
                } else if (widget.pageTitle == 'Manage Teacher') {
                  dis(ref);
                  context.push(Routes.addTeacher);
                } else if (widget.pageTitle == 'New Timetable') {
                  dis(ref);
                  ref.read(addNewTimetableProvider.notifier).setPosition(1);
                } else if (widget.pageTitle == 'Class Selection') {
                  dis(ref);
                  ref.read(addNewTimetableProvider.notifier).setPosition(2);
                  // context.pop();
                } else if (widget.pageTitle == 'Teacher Selection') {
                  dis(ref);
                  ref.read(addNewTimetableProvider.notifier).setPosition(3);
                  // context.pop();
                } else if (widget.pageTitle == 'Subject Selected') {
                  dis(ref);
                  ref.read(addNewTimetableProvider.notifier).setPosition(4);
                  // context.pop();
                } else if (widget.pageTitle == 'Generate Timetable') {
                  dis(ref);
                  widget.timetableItself?.call();
                } else {
                  context.push(Routes.addNewTime);
                }
              },
              child: Text('${widget.buttonName}',
                  style: const TextStyle(color: Colors.orange)));
        },
      ),
    );
  }

  dis(ref) {
    ref.invalidate(timetableProvider);
    ref.invalidate(classProvider);
    ref.invalidate(freeSlotProvider);
    ref.invalidate(subjectProvider);
    ref.invalidate(teacherProvider);
    ref.invalidate(teacherProvider);
  }
}
