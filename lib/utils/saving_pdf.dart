import 'dart:io';

import 'package:flutter/services.dart'; // For rootBundle
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class TimetablePdfGenerator {
  final List timetableData1;
  final List timetableData2;
  final List timetableData3;
  final List timetableData4;
  final String department;

  TimetablePdfGenerator({
    required this.timetableData1,
    required this.timetableData2,
    required this.timetableData3,
    required this.timetableData4,
    required this.department,
  });

  // Function to generate the timetable PDF
  Future<bool> generateTimetablePdf() async {
    try {
      final pdf = pw.Document();

      // Load the font from assets
      final fontData =
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final font = pw.Font.ttf(fontData);

      // Add a page to the PDF document
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4, // A4 size page
          build: (pw.Context context) {
            return pw.Column(
              children: [
                // Add the 4 timetables one below the other
                pw.Text('$department: University of Turbat'),
                pw.SizedBox(
                  height: 3,
                ),
                _buildTimetable(context, timetableData1),
                pw.SizedBox(height: 8),
                _buildTimetable(context, timetableData2),
                pw.SizedBox(height: 8),
                _buildTimetable(context, timetableData3),
                pw.SizedBox(height: 8),
                _buildTimetable(context, timetableData4),
              ],
            );
          },
        ),
      );

      // Save the PDF to the device
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/timetable.pdf");
      await file.writeAsBytes(await pdf.save());

      print("PDF saved to ${file.path}");
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Function to build a single timetable
  pw.Widget _buildTimetable(pw.Context context, List timetableData) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      padding: const pw.EdgeInsets.all(4), // Reduced padding
      child: pw.Column(
        children: [
          // Title
          pw.Text(
            timetableData[0][0]['semester'],
            style: pw.TextStyle(
              fontSize: 10, // Slightly smaller font size
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),

          // Header Row for Days of the week
          pw.Row(
            children: [
              // Empty cell for time slots column
              _buildTableCell(''),
              // Days of the week (smaller font size)
              for (String day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'])
                _buildTableCell(day),
            ],
          ),

          // Rows for time slots (9:30 AM, 11:30 AM, etc.)
          for (String timeSlot in ['9:30 AM', '11:30 AM', '1:30 PM', '2:30 PM'])
            pw.Row(
              children: [
                // Time slot column
                _buildTableCell(timeSlot),
                // Timetable cells for each day
                for (String day in [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday'
                ])
                  _buildTableCell(_getCellData(day, timeSlot, timetableData)),
              ],
            ),
        ],
      ),
    );
  }

  // Helper function to build a single table cell with border
  pw.Widget _buildTableCell(String content) {
    return pw.Expanded(
      child: pw.Center(
        child: pw.Text(
          content,
          style: pw.TextStyle(fontSize: 8), // Smaller font size
        ),
      ),
    );
  }

  // Helper function to get the timetable data or display "Break"
  String _getCellData(String day, String timeSlot, List timetableData) {
    // Flatten the timetable data
    var flattenedTimetable = timetableData.expand((list) => list).toList();

    // Find entry for the current day and slot
    var cellData = flattenedTimetable.firstWhere(
      (entry) => entry['day_of_week'] == day && entry['slot'] == timeSlot,
      orElse: () => null,
    );

    // If no data, display "Break"
    return cellData == null ? 'Break' : cellData['subject_name'] ?? 'N/A';
  }
}
