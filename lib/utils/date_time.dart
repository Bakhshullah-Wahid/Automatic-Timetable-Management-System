import 'package:flutter/material.dart';

class DateTimeHelper {
  // This function returns time in AM and PM format, e.g., {10:20 PM/AM}
  static Future<String> getFormattedTime(TimeOfDay time) async {
    int hour = time.hourOfPeriod, minute = time.minute;
    String currentTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
    return currentTime;
  }

  // This function provides the facility to select time
  static Future<String> pickTime(
      TimeOfDay initialTime, BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme originalColorScheme = theme.colorScheme;

    // Customize the primary color temporarily
    ThemeData customTheme = theme.copyWith(
      colorScheme: originalColorScheme.copyWith(primary: Colors.black),
    );

    // Show time picker dialog
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: customTheme,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    // If the user cancels, return the original time
    if (newTime == null) {
      return '';
      // getFormattedTime(initialTime); // Return initial time if cancelled
    }
    // Return the newly selected time
    return getFormattedTime(newTime);
  }
}
