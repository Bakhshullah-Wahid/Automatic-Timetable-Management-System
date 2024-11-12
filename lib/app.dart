import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/provider_dashboard.dart';
import 'route/my_routes.dart';
import 'utils/theme_data.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late bool logIn = ref.watch(isLoginProvider);
    late bool isAdminPages = ref.watch(isAdmin);
    return MaterialApp.router(
      title: "ATTMS",
      debugShowCheckedModeBanner: false,
      theme: Style.lightTheme(),
      routerConfig:
          // MyRouter.router3
          logIn
              ? isAdminPages
                  ? MyRouter.adminRouter
                  : MyRouter.coordinatorRouter
              : MyRouter.loginRouter,
    );
  }
}
