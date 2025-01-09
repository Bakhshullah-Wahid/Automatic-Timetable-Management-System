import 'package:attms/provider/dashboard_provider.dart';
import 'package:attms/screens/coordinator/requestTeacher/manage.dart';
import 'package:attms/utils/data/fetching_data.dart';
import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/coordinator/drawer_box.dart';
import 'teacher_request_screen.dart';

class TeacherRequestSystem extends StatefulWidget {
  const TeacherRequestSystem({super.key});

  @override
  ClassRequestSystemState createState() => ClassRequestSystemState();
}

class ClassRequestSystemState extends State<TeacherRequestSystem>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String departments = '';
  int deptId = 0;
  FetchingDataCall fetchingDataCall = FetchingDataCall();
  journal() async {
    var prefs2 = await SharedPreferences.getInstance();
    var deptPrefs = await SharedPreferences.getInstance();
    deptId = deptPrefs.getInt('deptId')!;
    departments = prefs2.getString('department').toString();
  }

  @override
  void initState() {
    super.initState();
    journal();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final bool mobileCheck = ref.watch(mobileDrawer);
        var formattedDepartments = fetchingDataCall.department(ref);
        var formattedTeacher = fetchingDataCall.teacher(ref);
        for (var i in formattedDepartments) {
          for (var j in formattedTeacher) {
            if (i['department_id'] == j['department_id']) {
              j['department_name'] = i['department_name'];
            }
          }
        }
     
        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  const TitleContainer(
                    description: "Request other Teacher",
                    pageTitle: 'Request For Teacher',
                  ),
                  TabBar(
                    indicatorColor: Colors.orange,
                    labelColor: Colors.orange,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "Request a Teacher"),
                      Tab(text: "Manage Requests"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        TeacherRequestScreens(
                          formattedTeacher: formattedTeacher,
                          departments: departments,
                          deptId: deptId,
                        ),
                        ManageTeacherRequestPage(
                          formattedTeacher: formattedTeacher,
                          departments: departments,
                          deptId: deptId,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              mobileCheck ? DrawerBox() : SizedBox.shrink(),
            ],
          ),
        );
      }),
    );
  }
}
