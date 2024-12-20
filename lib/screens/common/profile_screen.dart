import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleContainer(
              description: 'Who is Logged In',
              pageTitle: 'Profile',
              buttonName: 'Log Out',
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 50),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.displaySmall,
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
