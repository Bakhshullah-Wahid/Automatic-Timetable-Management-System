import 'package:flutter/material.dart';

class Style {
  static ThemeData lightTheme() {
    return ThemeData(
      listTileTheme: const ListTileThemeData(
        minVerticalPadding: 0,
        dense: true,
      ),
      useMaterial3: true,
      timePickerTheme: const TimePickerThemeData(
          backgroundColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white)),
      radioTheme: const RadioThemeData(
          fillColor: WidgetStatePropertyAll(Color(0xFFF1592A))),
      dividerTheme: DividerThemeData(
          color: const Color(0xFF0161CD).withValues(alpha: 0.1), thickness: 1),
      // drawerTheme: const DrawerThemeData(
      //     shape: ContinuousRectangleBorder(),
      //     elevation: 0,
      //     backgroundColor: Color(0xFF0161CD)),
      switchTheme: const SwitchThemeData(
          thumbIcon:
              WidgetStatePropertyAll(Icon(Icons.emoji_emotions_outlined)),
          trackOutlineColor: WidgetStatePropertyAll(
            Color(0xFF233D4D),
          ),
          trackColor: WidgetStatePropertyAll(
            Color(0xFF233D4D),
          ),
          thumbColor: WidgetStatePropertyAll(Color(0xFFF1592A))),
      dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.black)),
      iconTheme: const IconThemeData(color: Color(0xFFF1592A)),
      elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Color(0xFFF1592A)),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
              backgroundColor: WidgetStatePropertyAll(
                Color(0xFF233D4D),
              ))),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 5,
          // backgroundColor: Color(0xFF0161CD),
          iconTheme: IconThemeData(color: Colors.white)),
      cardTheme: const CardTheme(
          color: Color(0xFF0161CD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
      // text theme of the appp
      textTheme: const TextTheme(
          displaySmall: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(
              fontSize: 30,
              color: Color(0xFFF1592A),
              fontWeight: FontWeight.bold),
          displayLarge: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
              fontSize: 20,
              color: Color(0xFFF1592A),
              fontWeight: FontWeight.bold),
          bodyMedium:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodySmall: TextStyle(color: Color(0xFFF1592A))),
      drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
    );
  }
}
