import 'dart:math'; // Importing math for angle calculations
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TimeTrackerPage(),
  ));
}

class TimeTrackerPage extends StatefulWidget {
  @override
  _TimeTrackerPageState createState() => _TimeTrackerPageState();
}

class _TimeTrackerPageState extends State<TimeTrackerPage> {
  // Map to store activities for each day of the month (1 to 31)
  Map<int, List<Activity>> activitiesByDay = {};

  // Controllers for adding new activities
  final _activityController = TextEditingController();
  final _durationController = TextEditingController();
  int selectedDay = 1; // Default to day 1

  // Function to add activity to the selected day
  void _addActivity() {
    if (_activityController.text.isNotEmpty && _durationController.text.isNotEmpty) {
      setState(() {
        if (activitiesByDay[selectedDay] == null) {
          activitiesByDay[selectedDay] = [];
        }
        activitiesByDay[selectedDay]!.add(Activity(
          name: _activityController.text,
          duration: int.tryParse(_durationController.text) ?? 0,
        ));
      });
      _activityController.clear();
      _durationController.clear();
    }
  }

  // Function to edit activity
  void _editActivity(int day, int index) {
    _activityController.text = activitiesByDay[day]![index].name;
    _durationController.text = activitiesByDay[day]![index].duration.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Aktivitas'),
          content: Column(
            children: [
              TextField(
                controller: _activityController,
                decoration: InputDecoration(labelText: 'Nama Aktivitas'),
              ),
              TextField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Durasi (Menit)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  activitiesByDay[day]![index] = Activity(
                    name: _activityController.text,
                    duration: int.tryParse(_durationController.text) ?? 0,
                  );
                });
                Navigator.of(context).pop();
                _activityController.clear();
                _durationController.clear();
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _activityController.clear();
                _durationController.clear();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Function to delete activity
  void _deleteActivity(int day, int index) {
    setState(() {
      activitiesByDay[day]!.removeAt(index);
    });
  }

  // Function to calculate the total duration of all activities for a day
  int _getTotalDurationForDay(int day) {
    num total = 0; // Use num to allow for both int and double
    for (var activity in activitiesByDay[day] ?? []) {
      total += activity.duration;
    }
    return total.toInt(); // Explicitly cast total to an int before returning
  }

  // Function to get the pie chart angles for a selected day
  List<double> _getPieChartAnglesForDay(int day) {
    int totalDuration = _getTotalDurationForDay(day);
    List<double> angles = [];

    if (totalDuration == 0) return angles;

    for (var i = 0; i < (activitiesByDay[day]?.length ?? 0); i++) {
      double percentage = (activitiesByDay[day]![i].duration / totalDuration) * 360;
      angles.add(percentage);
    }

    return angles;
  }

  // Function to get the colors for each activity (keep original colors for pie chart)
  List<Color> _getColorsForChart() {
    return [
      Color(0xFFAA5486),
      Color(0xFFFC8F54),
      Color(0xFFFDE7BB),
      Color(0xFFFBF4DB),
    ];
  }

  // Function to select a day
  void _selectDay(int day) {
    setState(() {
      selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        backgroundColor: Color(0xFFFC8F54), // Primary color for the app bar
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Wrap the entire body in a scroll view
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Selection
            Text(
              'Pilih Hari',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFC8F54)),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: List.generate(31, (index) {
                int day = index + 1;
                return ChoiceChip(
                  label: Text('$day'),
                  selected: selectedDay == day,
                  onSelected: (_) => _selectDay(day),
                  selectedColor: Color(0xFFFBF4DB), // Lighter background for selected day
                  labelStyle: TextStyle(color: Colors.black),
                );
              }),
            ),
            SizedBox(height: 24),

            // Input Section for Activity
            Text(
              'Tambah Aktivitas untuk Hari $selectedDay',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFC8F54)),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _activityController,
              decoration: InputDecoration(
                labelText: 'Nama Aktivitas',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFFBF4DB), // Background color for input fields
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Durasi (Menit)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFFBF4DB),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addActivity,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFC8F54), // Main color for the button
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('Tambah Aktivitas'),
            ),
            SizedBox(height: 24),

            // Pie chart visualization
            Text(
              'Visualisasi Waktu Aktivitas untuk Hari $selectedDay',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFC8F54)),
            ),
            SizedBox(height: 8),
            if (activitiesByDay[selectedDay] != null && activitiesByDay[selectedDay]!.isNotEmpty)
              CustomPaint(
                size: Size(250, 250),
                painter: PieChartPainter(
                  angles: _getPieChartAnglesForDay(selectedDay),
                  colors: _getColorsForChart(),
                  activityNames: activitiesByDay[selectedDay]!.map((e) => e.name).toList(),
                ),
              )
            else
              Center(
                child: Text(
                  'Tidak ada aktivitas untuk ditampilkan',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

            SizedBox(height: 24),

            // List of activities for the selected day
            Text(
              'Daftar Aktivitas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFC8F54)),
            ),
            SizedBox(height: 8),
            activitiesByDay[selectedDay] == null || activitiesByDay[selectedDay]!.isEmpty
                ? Center(child: Text('Tidak ada aktivitas untuk ditampilkan'))
                : ListView.builder(
                    shrinkWrap: true, // Add shrinkWrap here to ensure the list does not overflow
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
                    itemCount: activitiesByDay[selectedDay]?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color(0xFFFDE7BB),
                        child: ListTile(
                          title: Text(activitiesByDay[selectedDay]![index].name),
                          subtitle: Text(
                            '${activitiesByDay[selectedDay]![index].duration} Menit',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _editActivity(selectedDay, index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteActivity(selectedDay, index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

// Activity class to represent an activity with its name and duration
class Activity {
  final String name;
  final int duration;

  Activity({required this.name, required this.duration});
}

// CustomPainter for the Pie Chart visualization
class PieChartPainter extends CustomPainter {
  final List<double> angles;
  final List<Color> colors;
  final List<String> activityNames;

  PieChartPainter({
    required this.angles,
    required this.colors,
    required this.activityNames,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    double startAngle = -90.0;
    for (int i = 0; i < angles.length; i++) {
      final sweepAngle = angles[i];
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        _degToRad(startAngle),
        _degToRad(sweepAngle),
        true,
        paint,
      );

      // Draw the label (name) for each segment
      final labelAngle = startAngle + sweepAngle / 2;
      final double x = size.width / 2 + (size.width / 4) * cos(_degToRad(labelAngle));
      final double y = size.height / 2 + (size.height / 4) * sin(_degToRad(labelAngle));

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: activityNames[i],
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));

      startAngle += sweepAngle; // Move to next segment
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  double _degToRad(double degree) {
    return degree * (pi / 180.0);
  }
}
