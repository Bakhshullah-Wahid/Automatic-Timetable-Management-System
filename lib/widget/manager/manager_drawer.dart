import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/provider_dashboard.dart';
import '../../responsive.dart';
import '../../route/navigations.dart';

class ManagerDrawerBox extends ConsumerStatefulWidget {
  const ManagerDrawerBox({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawerBoxState();
}

class _DrawerBoxState extends ConsumerState<ManagerDrawerBox> {
  List routing = [
    {'title': 'Dashboard', 'leading': Icons.dashboard},
    {'title': 'Manage Classes', 'leading': Icons.groups},
    {'title': 'Manage Department', 'leading': Icons.business},
    {'title': 'Manage Teacher', 'leading': Icons.person},
    {'title': 'Manage Subject', 'leading': Icons.menu_book},
    {'title': 'Profile', 'leading': Icons.account_circle},
    {'title': 'About Us', 'leading': Icons.info},
  ];

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    final position = ref.watch(dashboardProvider);

    return Container(
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black12, width: 5))),
      child: Drawer(
        surfaceTintColor: Colors.white,
        width: mediaquery.width * 0.15,
        semanticLabel: 'Dashboard',
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: mediaquery.height * 0.008,
              // height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 50,
                  child: DrawerHeader(
                      child: Image.asset(
                    'assets/images/tabletime-01.png',
                    scale: 4,
                  ))),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: mediaquery.height * 0.05),
                child: ListView.builder(
                  itemCount: routing.length,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          child: position == index
                              ? Container(
                                  width: mediaquery.width * 0.25,
                                  height: mediaquery.height * 0.04,
                                  decoration: BoxDecoration(
                                      // Background color of the container
                                      borderRadius: BorderRadius.circular(
                                          8), // Optional: rounded corners
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                              alpha:
                                                  0.1), // Shadow color with opacity
                                          offset:
                                              Offset(0, 7), // Shadow only below
                                          blurRadius:
                                              4, // Controls how blurry the shadow is
                                          spreadRadius:
                                              0.1, // Spread of the shadow
                                        ),
                                      ],
                                      color: Theme.of(context)
                                          .dialogTheme
                                          .backgroundColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 5),
                                    child: Text(
                                      Responsive.isMobile(context)
                                          ? routing[index]['title']
                                              .substring(0, 1)
                                          : routing[index]['title'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: mediaquery.height * 0.04,
                                  decoration: BoxDecoration(
                                      // Background color of the container
                                      borderRadius: BorderRadius.circular(
                                          8), // Optional: rounded corners
                                      boxShadow: Responsive.isMobile(context)
                                          ? null
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                    alpha:
                                                        0.2), // Shadow color with opacity
                                                offset: Offset(
                                                    0, 1), // Shadow only below
                                                blurRadius:
                                                    3, // Controls how blurry the shadow is
                                                spreadRadius:
                                                    0.4, // Spread of the shadow
                                              ),
                                            ],
                                      color: Theme.of(context)
                                          .dialogTheme
                                          .backgroundColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          routing[index]['leading'],
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: mediaquery.width * 0.002,
                                        ),
                                        if (!Responsive.isMobile(context))
                                          Text(routing[index]['title'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                          onTap: () {
                            if (index == 0 ||
                                index == 1 ||
                                index == 2 ||
                                index == 3 ||
                                index == 4 ||
                                index == 5 ||
                                index == 6) {
                              ref
                                  .read(dashboardProvider.notifier)
                                  .setPosition(index);

                              switch (index) {
                                case 0:
                                  context.go(Routes.managerAdmin);
                                  break;

                                case 1:
                                  context.go(Routes.manageClass);
                                  break;
                                case 2:
                                  context.go(Routes.manageDepartment);

                                  break;
                                case 3:
                                  context.go(Routes.teacherView);

                                  break;
                                case 4:
                                  context.go(Routes.manageSubject);
                                  break;
                                case 5:
                                  context.go(Routes.profile);

                                  break;
                                case 6:
                                  context.go(Routes.aboutUs);
                                  break;

                                default:
                              }
                            }
                          }),
                      Divider(
                        color: Colors.black.withValues(alpha: 0.1),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
