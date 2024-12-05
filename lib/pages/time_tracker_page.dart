import 'dart:math'; // Importing math for angle calculations
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

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
  Map<int, List<Activity>> activitiesByDay = {}; // Store activities
  final _activityController = TextEditingController();
  final _durationController = TextEditingController();
  int selectedDay = 1;

  @override
  void initState() {
    super.initState();
    _loadActivitiesFromPreferences(); // Load activities when the page is opened
  }

  // Function to save activities to SharedPreferences
  void _saveActivitiesToPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert activities map to a list of strings for simplicity
    List<String> activitiesList = activitiesByDay[selectedDay]!.map((activity) {
      return '${activity.name}:${activity.duration}'; // Format as 'activityName:duration'
    }).toList();

    await prefs.setStringList('activities_day_$selectedDay', activitiesList);
  }

  // Function to load activities from SharedPreferences
  void _loadActivitiesFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedActivities = prefs.getStringList('activities_day_$selectedDay');

    if (savedActivities != null) {
      setState(() {
        activitiesByDay[selectedDay] = savedActivities.map((activityStr) {
          final parts = activityStr.split(':');
          return Activity(
            name: parts[0],
            duration: int.parse(parts[1]),
          );
        }).toList();
      });
    }
  }

  // Function to add activity
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
      _saveActivitiesToPreferences(); // Save the new data to SharedPreferences
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
                _saveActivitiesToPreferences(); // Save the updated data
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
    _saveActivitiesToPreferences(); // Save after deleting activity
  }

  // Function to calculate the total duration of all activities for a day
  int _getTotalDurationForDay(int day) {
    num total = 0;
    for (var activity in activitiesByDay[day] ?? []) {
      total += activity.duration;
    }
    return total.toInt();
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

  // Function to get the colors for each activity (for pie chart)
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
    _loadActivitiesFromPreferences(); // Reload activities when day is changed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        backgroundColor: Color(0xFFFC8F54),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  selectedColor: Color(0xFFFBF4DB),
                  labelStyle: TextStyle(color: Colors.black),
                );
              }),
            ),
            SizedBox(height: 24),
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
                fillColor: Color(0xFFFBF4DB),
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
                backgroundColor: Color(0xFFFC8F54),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text('Tambah Aktivitas'),
            ),
            SizedBox(height: 24),
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
            Text(
              'Daftar Aktivitas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFC8F54)),
            ),
            SizedBox(height: 8),
            activitiesByDay[selectedDay] == null || activitiesByDay[selectedDay]!.isEmpty
                ? Center(child: Text('Tidak ada aktivitas untuk ditampilkan'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
