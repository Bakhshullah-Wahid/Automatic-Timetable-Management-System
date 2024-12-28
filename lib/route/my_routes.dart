import 'package:attms/preference/shared_preferenced.dart';
import 'package:attms/screens/common/log_in_screen.dart';
import 'package:attms/screens/manager/class/class_view.dart';
import 'package:attms/screens/manager/department/add_department.dart';
import 'package:attms/screens/manager/department/manage_department_view.dart';
import 'package:attms/wholeData/class/update_class.dart';
import 'package:attms/wholeData/coordinator/update_user.dart';
import 'package:attms/wholeData/department/update_department.dart';
import 'package:attms/wholeData/teacher/update_teacher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/coordinator/requestClasses/request.dart';
import '../wholeData/subject/update_subject.dart';
import './all_screens.dart';
import 'navigations.dart';

class MyRouter {
  MyRouter._(); //this is to prevent anyone from instantiating this object

  late bool logIn = ThemePrefs.getLogin();
  late bool value = ThemePrefs.getIsAdmin();
  static final GlobalKey<NavigatorState> _shellNavigator =
      GlobalKey(debugLabel: 'shell');
  static final adminRouter = GoRouter(
    initialLocation: Routes.managerAdmin,
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) => ManagerDashboardScreen(
                key: state.pageKey,
                child: child,
              ),
          routes: [
            GoRoute(
              path: Routes.addAccount,
              name: 'add_account',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AddAccountScreen(
                    updatedData: state.extra as UpdateAccount?),
              ),
            ),
            GoRoute(
              path: Routes.addSubject,
              name: 'add_subject',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AddSubjectScreen(
                    updateSubject: state.extra as UpdateSubject?),
              ),
            ),
            GoRoute(
              path: Routes.manageSubject,
              name: 'manage_subject',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SubjectView(),
              ),
            ),
            GoRoute(
              path: Routes.manageClass,
              name: 'manage_class',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ClassView(),
              ),
            ),
            GoRoute(
              path: Routes.addClass,
              name: 'add_class',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AddClassScreen(
                  updatedClass: state.extra as UpdateClass?,
                ),
              ),
            ),
            GoRoute(
              path: Routes.addDepartment,
              name: 'add_department',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AddDepartmentScreen(
                  updatedDepartment: state.extra as UpdateDepartment?,
                ),
              ),
            ),
            GoRoute(
              path: Routes.manageDepartment,
              name: 'manage_department',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ManageDepartmentView(),
              ),
            ),
            GoRoute(
                path: Routes.managerAdmin,
                name: 'manager',
                pageBuilder: (context, state) => NoTransitionPage(
                      child: ManagerScreen(),
                    )),
            GoRoute(
                path: Routes.aboutUs,
                name: 'about_us',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: AboutUs(),
                    )),
            GoRoute(
                path: Routes.profile,
                name: 'profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: ProfileScreen(),
                    )),
            GoRoute(
                path: Routes.teacherView,
                name: 'teacher_view',
                pageBuilder: (context, state) => NoTransitionPage(
                      child: TeacherView(),
                    )),
            GoRoute(
              path: Routes.addTeacher,
              name: 'add_teacher',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AddTeacherScreen(
                  updateTeacher: state.extra as UpdateTeacher?,
                ),
              ),
            ),
          ]),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
  static final loginRouter = GoRouter(
    initialLocation: Routes.logIn,
    routes: [
      GoRoute(
          path: Routes.logIn,
          name: "log_in",
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LogInPage())),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
  static final coordinatorRouter = GoRouter(
    initialLocation: Routes.home,
    routes: [
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) {
            bool showNavBar = state.uri.toString() != Routes.addNewTime;
            return DashBoardScreen(
              key: state.pageKey,
              showNavigationBar: showNavBar,
              child: child,
            );
          },
          routes: [
            GoRoute(
                path: Routes.home,
                name: "home",
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: HomeScreens())),
            GoRoute(
                path: Routes.addNewTime,
                name: "add_new_time",
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: NewTimeTableScreen(),
                    )),
            GoRoute(
              path: Routes.manageSubject,
              name: 'manage_subject',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SubjectView(),
              ),
            ),
            GoRoute(
                path: Routes.viewTimeTable,
                name: 'view_timetable',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: ViewTimetableScreen(),
                    )),
            GoRoute(
                path: Routes.aboutUs,
                name: 'about_us',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: AboutUs(),
                    )),
            GoRoute(
                path: Routes.classRequest,
                name: 'class_request',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: ClassRequestSystem(),
                    )),
            GoRoute(
                path: Routes.profile,
                name: 'profile',
                pageBuilder: (context, state) => const NoTransitionPage(
                      child: ProfileScreen(),
                    )),
          ]),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}
