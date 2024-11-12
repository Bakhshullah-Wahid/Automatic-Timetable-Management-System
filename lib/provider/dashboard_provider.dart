import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardProvider extends StateNotifier<int> {
  DashboardProvider(super.state);
  void setPosition(int value) {
    state = value;
  }
}