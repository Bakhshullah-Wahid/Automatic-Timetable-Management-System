import 'package:riverpod/riverpod.dart';

final addNewTimetableProvider =
    StateNotifierProvider<AddNewTimeProvider, int>((ref) {
  return AddNewTimeProvider(0);
});

class AddNewTimeProvider extends StateNotifier<int> {
  AddNewTimeProvider(super.state);
  void setPosition(int value) {
    state = value;
  }
}
