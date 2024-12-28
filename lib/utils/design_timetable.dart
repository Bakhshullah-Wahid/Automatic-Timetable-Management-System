import 'package:flutter/material.dart';

class TimetableDesign extends StatelessWidget {
  final List timetable;
  final String department;
  const TimetableDesign(
      {super.key, required this.timetable, required this.department});

  @override
  Widget build(BuildContext context) {
    return buildTimetableView(timetable, department);
  }

  Widget buildTimetableView(List timetable, department) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Header Row for Days
          Row(
            children: [
              // Empty cell for time slots column
              Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Days of the week
              for (String day in [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday'
              ])
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Rows for time slots
          for (String timeSlot in ['9:30 AM', '11:30 AM', '1:30 PM', '2:30 PM'])
            Row(
              children: [
                // Time slot column
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      timeSlot,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Timetable cells for each day
                for (String day in [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday'
                ])
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Builder(
                        builder: (context) {
                          // Flatten the timetable data
                          var flattenedTimetable =
                              timetable.expand((list) => list).toList();

                          // Find entry for the current day and slot
                          var cellData = flattenedTimetable.firstWhere(
                            (entry) =>
                                entry['day_of_week'] == day &&
                                entry['slot'] == timeSlot,
                            orElse: () => null,
                          );

                          // If no data, display "Break"
                          if (cellData == null) {
                            return timeSlot == '2:30 PM'
                                ? SizedBox.shrink()
                                : Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.blue.withOpacity(0.3))),
                                    child: Center(
                                      child: Text(
                                        'Break',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                          }

                          // Display subject, class, teacher, and slot
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.3))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      cellData['subject_name'] ?? 'N/A',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      cellData['class_name'] ?? 'N/A',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    Text(
                                      cellData['teacher_name'] ?? 'N/A',
                                      style:
                                          const TextStyle(color: Colors.orange),
                                    ),
                                    department == cellData['class_department']
                                        ? SizedBox.shrink()
                                        : Text(
                                            cellData['class_department'] ??
                                                'N/A',
                                            style: const TextStyle(
                                                color: Colors.purple),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
