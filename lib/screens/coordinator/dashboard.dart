import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/add_new_time_provider.dart';
import '../../widget/coordinator/drawer_box.dart';

class DashBoardScreen extends StatefulWidget {
  final Widget child;
  final bool showNavigationBar;
  const DashBoardScreen({
    required this.child,
    super.key,
    this.showNavigationBar = true,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List buttonsName = ['Dashboard', 'Add New TimeTable', 'Log Out'];
  late int position;
  List routing = [
    {
      'title': 'Select Semester And Time',
    },
    {
      'title': 'Select Class',
    },
    {
      'title': 'Select Teacher',
    },
    {
      'title': 'Subjects',
    },
    {
      'title': 'Generate Timetable',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: widget.showNavigationBar
            ? SizedBox() // Navigation bar hidden
            : Column(
                children: [
                  AppBar(
                    backgroundColor:
                        Colors.white, // Explicitly set background color
                    elevation: 0, // Remove shadow if needed
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            return TextButton(
                              onPressed: () {
                                context.pop();
                                ref
                                    .read(addNewTimetableProvider.notifier)
                                    .setPosition(0);
                              },
                              child: Text(
                                'Back',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            );
                          },
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            position = ref.watch(addNewTimetableProvider);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: List.generate(
                                routing.length,
                                (index) {
                                  Color textColor = position == index
                                      ? Colors.orange
                                      : Colors.black;

                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(
                                              addNewTimetableProvider.notifier)
                                          .setPosition(index);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (position == index)
                                          const Icon(
                                            size: 15,
                                            Icons.circle,
                                            color: Colors.orange,
                                          ),
                                        Text(
                                          routing[index]['title'] ??
                                              'Button $index',
                                          style: TextStyle(color: textColor),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 50, bottom: 20),
        child: Text(
          'University of Turbat',
          style: TextStyle(color: Colors.black.withOpacity(0.2)),
        ),
      ),
      body: Row(
        children: [
          widget.showNavigationBar
              ? const DrawerBox()
              : const SizedBox.shrink(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: widget.child,
          )),
        ],
      ),
    );
  }
}
