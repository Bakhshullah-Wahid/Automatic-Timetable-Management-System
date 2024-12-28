import 'package:flutter_riverpod/flutter_riverpod.dart';

final mobileDrawer = StateNotifierProvider<MobileDrawerProvider, bool>((ref) {
  return MobileDrawerProvider(false);
});
class DashboardProvider extends StateNotifier<int> {
  DashboardProvider(super.state);
  void setPosition(int value) {
    state = value;
  }
}

class MobileDrawerProvider extends StateNotifier<bool> {
  MobileDrawerProvider(super.state);
  void setPositionMobile() {
    state = !state;
  }
}
