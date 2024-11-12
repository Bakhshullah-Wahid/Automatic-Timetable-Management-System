import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/provider_dashboard.dart';
import '../../route/navigations.dart';
 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    valueget();
    coordinatorData();
    super.initState();
  }

  String name = '';
  String department = '';
  List<Map<String, dynamic>> dataList = []; 
  void coordinatorData() async { 
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i]['email'] == profileId) {
        name = dataList[i]['name'];

        department = dataList[i]['department'];
        break;
      }
    }
    setState(() {});
  }

  String profileId = '';
  valueget() async {
    var prefs2 = await SharedPreferences.getInstance();
    profileId = prefs2.getString('Email').toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 300,
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
                    'Profile',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Consumer(
                    builder: (context, ref, child) => TextButton(
                        onPressed: () {
                          late bool value = ref.watch(isAdmin);
                          ref.read(dashboardProvider.notifier).setPosition(0);

                          if (value) {
                            context.go(Routes.managerAdmin);
                          } else {
                            context.go(Routes.home);
                          }
                          ref.read(isLoginProvider.notifier).loginTime();
                          // ref.read(isAdmin.notifier).showTime1();
                        },
                        child: const Text('Logout')),
                  )
                ],
              ),
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.1)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 50),
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 50),
                        child: CircleAvatar(
                          maxRadius: 20,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profileId,
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        Text(department,
                            style: const TextStyle(color: Colors.black))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
