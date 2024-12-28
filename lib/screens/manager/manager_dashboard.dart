import 'package:attms/widget/manager/manager_drawer.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';

class ManagerDashboardScreen extends StatefulWidget {
  final Widget child;
  const ManagerDashboardScreen({required this.child, super.key});

  @override
  State<ManagerDashboardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<ManagerDashboardScreen> { 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (!Responsive.isMobile(context)) const ManagerDrawerBox(),
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
