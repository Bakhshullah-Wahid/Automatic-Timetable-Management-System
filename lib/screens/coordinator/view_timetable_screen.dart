import 'package:flutter/material.dart';

class ViewTimetableScreen extends StatefulWidget {
  const ViewTimetableScreen({super.key});

  @override
  State<ViewTimetableScreen> createState() => _ViewTimetableScreenState();
}

class _ViewTimetableScreenState extends State<ViewTimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double minWidth = 300;
      double maxWidth = 800;
      double minHeight = 500;
      double maxHeight = 1000;
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
          maxHeight: maxHeight,
        ),
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TimeTable',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const Divider(),
              Column(
                children: [
                  Text('University Of Turbat',
                      style: Theme.of(context).textTheme.displayLarge),
                  Text('Department of Computer Science',
                      style: Theme.of(context).textTheme.bodySmall),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: constraints.minWidth < 800
                                      ? const Icon(Icons.watch_later)
                                      : Text('Timings',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      constraints.minWidth < 800
                                          ? 'M'
                                          : 'Monday',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      constraints.minWidth < 800
                                          ? 'T'
                                          : 'Tuesday',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      constraints.minWidth < 800
                                          ? 'W'
                                          : 'Wednesday',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      constraints.minWidth < 800
                                          ? 'T'
                                          : 'Thursday',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      constraints.minWidth < 800
                                          ? 'F'
                                          : 'Friday',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium))),
                          TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      constraints.minWidth < 800
                                          ? 'S'
                                          : 'Saturday',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium))),
                        ],
                      ),
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),
                      const TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 2, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 2, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 2, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 2, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 2, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 2, Col 6'))),
                        ],
                      ),
                      // Add more TableRows as needed
                    ],
                  ),
                  Text('BSCS 3rd',
                      style: Theme.of(context).textTheme.bodySmall),
                  Table(
                    border: TableBorder.all(),
                    children: const [
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Monday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Monday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tuesday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Wednesday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Thursday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Friday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Saturday',
                                  ))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),

                      // Add more TableRows as needed
                    ],
                  ),
                  Text('BSCS 5th',
                      style: Theme.of(context).textTheme.bodySmall),
                  Table(
                    border: TableBorder.all(),
                    children: const [
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Monday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Monday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tuesday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Wednesday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Thursday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Friday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Saturday',
                                  ))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),

                      // Add more TableRows as needed
                    ],
                  ),
                  Text('BSCS 7th',
                      style: Theme.of(context).textTheme.bodySmall),
                  Table(
                    border: TableBorder.all(),
                    children: const [
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Monday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Monday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tuesday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Wednesday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Thursday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Friday',
                                  ))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Saturday',
                                  ))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 1'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 2'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 3'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 4'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 5'))),
                          TableCell(
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Row 1, Col 6'))),
                        ],
                      ),

                      // Add more TableRows as needed
                    ],
                  ),
                ],
              )
            ],
          ),
        )),
      );
    });
  }
}
