import 'package:attms/widget/title_container.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List welcome = [
    // {'name': 'TimeTable 1', 'date': '1/2/2010'},
    // {'name': 'TimeTable 1', 'date': '2/2/2010'},
    // {'name': 'TimeTable 1', 'date': '1/2/2010'}
  ];
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const TitleContainer(
              pageTitle: 'Dashboard',
              buttonName: 'Add New Timetable',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: welcome.isEmpty
                    ? const Center(
                        child: Text(
                          'No Timetable Generated',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    : GroupedListView<dynamic, String>(
                        elements: welcome,
                        groupBy: (element) {
                          return element['date'];
                        },
                        order: GroupedListOrder.ASC,
                        groupSeparatorBuilder: (String groupByValue) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  groupByValue,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                        itemBuilder: (context, dynamic element) => ListTile(
                              title: Row(
                                children: [
                                  SizedBox(
                                    width: mediaquery.width * 0.7,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.1))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            element['name'],
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.visibility,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  SizedBox(
                                    width: mediaquery.width * 0.001,
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.delete,
                                          color: Colors.black.withOpacity(0.8)
                                          //  Theme.of(context).iconTheme.color,
                                          ))
                                ],
                              ),
                            )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
