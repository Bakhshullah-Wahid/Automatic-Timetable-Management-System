import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../preference/shared_preferenced.dart';
import 'dashboard_provider.dart';

final dashboardProvider = StateNotifierProvider<DashboardProvider, int>((ref) {
  return DashboardProvider(0);
});


final isLoginProvider = StateNotifierProvider<IsLoginProvider, bool>((ref) {
  return IsLoginProvider();
});

class IsLoginProvider extends StateNotifier<bool> {
  IsLoginProvider() : super(ThemePrefs.getLogin());
  void loginTime() {
    state = !state;
    ThemePrefs.setLogin(state);
  }
}

final isAdmin = StateNotifierProvider<IsAdmin, bool>((ref) {
  return IsAdmin();
});

class IsAdmin extends StateNotifier<bool> {
  IsAdmin() : super(ThemePrefs.getIsAdmin());
  void adminTime() {
    state = !state;
    ThemePrefs.setIsAdmin(state);
  }
}
