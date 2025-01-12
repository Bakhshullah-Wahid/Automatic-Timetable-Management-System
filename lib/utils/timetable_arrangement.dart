import '../services/freeSlots/fetch_free_slots.dart';
import '../services/timetable/fetch_timetable.dart';

class TimingManage {
  final List days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  Future<dynamic> timetableManaging(List timetable) async {
    List timetable1 = [];

    Map<String, List<Map<String, String>>> groupData = {};

    for (var entry in timetable) {
      String day = entry['day_of_week']!;

      if (!groupData.containsKey(day)) {
        groupData[day] = [];
      }

      groupData[day]!.add({
        'department_id': entry['department_id'].toString(),
        'subject_id': entry['subject_id'].toString(),
        'teacher_id': entry['teacher_id'].toString(),
        'class_id': entry['class_id'].toString(),
        'subject_name': entry['subject_name'].toString(),
        'teacher_name': entry['teacher_name'].toString(),
        'teacher_department': entry['teacher_department'].toString(),
        'class_name': entry['class_name'].toString(),
        'class_department': entry['class_department'].toString(),
        'day_of_week': entry['day_of_week'].toString(),
        'slot': entry['slot'].toString(),
        'semester': entry['semester'].toString(),
      });
    }

// Add the grouped data to `timetable3` for each day
    for (var day in days) {
      List<Map<String, String>> dayTimetable = groupData[day] ?? [];
      timetable1.add(dayTimetable);
    }
    return timetable1;
  }

  Future<dynamic> timetableGenerate(c, s, g) async {
    List classes = c;
    List semester = s;
    List generates = g;

    List itemsToRemove = [];

    classes.shuffle();
    List generatedTimetable = [];
    for (int sub = 0; sub < semester.length; sub++) {
      bool slotAssigned = false;
      // Iterate over class slots for semester 7 and 8
      for (var dash in classes) {
        // Check if the teacher is already assigned a class in any timetable at the same slot
        bool teacherConflict = generates.any((entry) =>
            entry['teacher_id'] == semester[sub]['teacher_id'] &&
            entry['day_of_week'] == dash['day_of_week'] &&
            entry['slot'] == dash['slot']);
        // Skip the current slot if a conflict is detected
        if (teacherConflict) {
          continue;
        }
        // Assign the slot if no conflict
        generatedTimetable.add({
          'subject_id': semester[sub]['subject_id'],

          'department_id': semester[sub]['department_id'],
          'class_id': dash['class_id'],
          'subject_name': semester[sub]['subject_name'],
          'teacher_name': semester[sub]['teacher_name'],
          'teacher_department': semester[sub]['teacher_department'],
          'teacher_id': semester[sub]['teacher_id'], // For conflict check
          'semester': semester[sub]['semester'],
          'department_name': semester[sub]['department_name'],
          'day_of_week': dash['day_of_week'],
          'class_name': dash['class_name'],
          'class_department': dash['class_department'],
          'slot': dash['slot']
        });

        // Mark the assigned slot to be removed later
        itemsToRemove.addAll(classes.where((item) =>
            item['day_of_week'].toLowerCase() ==
                dash['day_of_week'].toLowerCase() &&
            item['slot'].toLowerCase() == dash['slot'].toLowerCase()));

        slotAssigned = true;
        break; // Exit the inner loop after successfully assigning a slot
      }

      // Retry slot assignment if the first attempt failed
      if (!slotAssigned) {
        for (var dash in classes) {
          bool teacherConflict = generates.any((entry) =>
              entry['teacher_id'] == semester[sub]['teacher_id'] &&
              entry['day_of_week'] == dash['day_of_week'] &&
              entry['slot'] == dash['slot']);

          // Skip the slot if there's a conflict
          if (teacherConflict) {
            continue;
          }

          // Assign the slot if no conflict
          generatedTimetable.add({
            'subject_id': semester[sub]['subject_id'],

            'department_id': semester[sub]['department_id'],
            'class_id': dash['class_id'],
            'subject_name': semester[sub]['subject_name'],
            'teacher_name': semester[sub]['teacher_name'],
            'teacher_department': semester[sub]['teacher_department'],
            'teacher_id': semester[sub]['teacher_id'], // For conflict check
            'semester': semester[sub]['semester'],
            'department_name': semester[sub]['department_name'],
            'day_of_week': dash['day_of_week'],
            'class_name': dash['class_name'],
            'class_department': dash['class_department'],
            'slot': dash['slot']
          });

          // Mark the assigned slot for removal
          itemsToRemove.addAll(classes.where((item) =>
              item['day_of_week'].toLowerCase() ==
                  dash['day_of_week'].toLowerCase() &&
              item['slot'].toLowerCase() == dash['slot'].toLowerCase()));

          slotAssigned = true;
          break; // Exit after assigning a slot
        }
      }

      // Remove assigned slots from the available pool
      classes.removeWhere((item) => itemsToRemove.contains(item));
      itemsToRemove.clear(); // Clear for the next iteration
    }
    return generatedTimetable;
  }

  Future<dynamic> timetableDesignSheeet(generatedTimetable) async {
    List timetable = [];
    List days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    Map<String, List<Map<String, String>>> groupData = {};
    for (var entry in generatedTimetable) {
      String day = entry['day_of_week']!;
      if (!groupData.containsKey(day)) {
        groupData[day] = [];
      }

      groupData[day]!.add({
        'department_id': entry['department_id'].toString(),
        'subject_id': entry['subject_id'].toString(),
        'teacher_id': entry['teacher_id'].toString(),
        'class_id': entry['class_id'].toString(),
        'subject_name': entry['subject_name']!,
        'teacher_name': entry['teacher_name']!,
        'teacher_department': entry['teacher_department']!,
        'class_name': entry['class_name']!,
        'class_department': entry['class_department'],
        'day_of_week': entry['day_of_week']!,
        'slot': entry['slot']!,
        'semester': entry['semester']!,
      });
    }

// Add the grouped data to `timetable3` for each day
    for (var day in days) {
      List<Map<String, String>> dayTimetable = groupData[day] ?? [];
      timetable.add(dayTimetable);
    }

    return timetable;
  }

  Future<bool> savingTimetable(generatedTimetableee, depart) async {
    ScheduleService s = ScheduleService();
    FreeSlotServices free = FreeSlotServices();

    try {
      for (var t1 in generatedTimetableee) {
        bool isAdded = false;
        while (!isAdded) {
          isAdded = await s.addTimetable(
            t1['class_id'],
            t1['subject_id'],
            t1['teacher_id'],
            t1['day_of_week'],
            t1['slot'],
            t1['semester'],
            depart,
            t1['teacher_department'],
            t1['class_department'],
          );
        }
        bool isDeleted = false;
        while (!isDeleted) {
          isDeleted = await free.deleteFreeSlot(
              t1['class_id'], t1['slot'], t1['day_of_week']);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> removeBookedClasses(classes, generatedTimetableNone) async {
    for (var gen in generatedTimetableNone) {
      for (var item in classes) {
        if (gen['day_of_week'].toLowerCase() ==
                item['day_of_week'].toLowerCase() &&
            gen['slot'].toLowerCase() == item['slot'].toLowerCase() &&
            gen['class_name'] == item['class_name']) {
          await classes.remove(item);

          // Mark the item for removal
          break;
        }
      }
    }
    return classes;
  }
}
