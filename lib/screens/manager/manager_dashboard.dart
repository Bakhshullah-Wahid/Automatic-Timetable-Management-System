import 'package:attms/widget/manager/manager_drawer.dart';
import 'package:flutter/material.dart';

class ManagerDashboardScreen extends StatefulWidget {
  final Widget child;
  const ManagerDashboardScreen({required this.child, super.key});

  @override
  State<ManagerDashboardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<ManagerDashboardScreen> {
  List buttonsName = ['Dashboard', 'Add New TimeTable', 'Log Out'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 5,
      //   bottom: PreferredSize(
      //     preferredSize:
      //         const Size.fromHeight(4.0), // Height of the bottom color area
      //     child: Container(
      //       // Color of the bottom section
      //       height: 5.0, // You can adjust this height as needed
      //     ),
      //   ),
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const Text(
      //         'University of Turbat',
      //         style: TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.normal,
      //             fontSize: 15),
      //       ),
      //       Text(
      //         'AUTOMATIC TIMETABLE MANAGEMENT SYSTEM',
      //         style: Theme.of(context).textTheme.displayLarge,
      //       ),
      //     ],
      //   ),
      // ),
      body: Row(
        children: [
          const ManagerDrawerBox(),
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
