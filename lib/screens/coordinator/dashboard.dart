import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      'title': 'Subjects',
    },
    {
      'title': 'Select Class',
    },
    {
      'title': 'Select Teacher',
    },
    {
      'title': 'Generate Timetable',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0161CD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: 5,
            color: Color(0xFF0161CD),
          ))),
          child: widget.showNavigationBar
              ? AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'University of Turbat',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'AUTOMATIC TIMETABLE MANAGEMENT SYSTEM',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                )
              : AppBar(
                  title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AUTOMATIC TIMETABLE MANAGEMENT SYSTEM',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        position = ref.watch(addNewTimetableProvider);
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(
                              routing.length,
                              (index) {
                                // Determine the button color based on the position

                                Color textColor = position == index
                                    ? Colors.orange
                                    : Colors.black;

                                return TextButton(
                                  style: TextButton.styleFrom(
                                    // Optional: Add padding for better button appearance
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(addNewTimetableProvider.notifier)
                                        .setPosition(index);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      position == index
                                          ? const Icon(
                                              size: 15,
                                              Icons.circle,
                                              color: Colors.orange,
                                            )
                                          : Container(),
                                      Text(
                                        routing[index]['title'] ??
                                            'Button $index',
                                        style: TextStyle(
                                          color: textColor,
                                        ), // Set text color based on selection
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ));
                      },
                    ),
                  ],
                )),
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
