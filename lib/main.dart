import 'package:attms/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_size/window_size.dart';

import 'preference/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    setWindowMinSize(Size(300, 500)); // Set minimum width and height
  });
  await Prefs.init();
  await Prefs1.init1();
  runApp(const ProviderScope(child: MyApp()));
}
