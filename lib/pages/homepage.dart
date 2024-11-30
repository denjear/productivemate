import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'learning_methods_page.dart'; // Import Learning Methods Page
import 'task_list_page.dart'; // Import Task List Page
import 'timer_page.dart';
import 'settings_page.dart'; // Import Settings Page
import 'time_tracker_page.dart'; // Import Time Tracker Page

void main() {
  runApp(ProductivityApp());
}

class ProductivityApp extends StatefulWidget {
  const ProductivityApp({super.key});

  @override
  _ProductivityAppState createState() => _ProductivityAppState();
}

class _ProductivityAppState extends State<ProductivityApp> {
  bool _isDarkMode = false; // Variable for Dark Mode status

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load Dark Mode settings from SharedPreferences
  }

  // Load Dark Mode settings from SharedPreferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Get Dark Mode setting
    });
  }

  // Light Mode Theme
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue, // Main color for Light Mode
      scaffoldBackgroundColor: Colors.white, // Scaffold background color
      appBarTheme: AppBarTheme(
        color: Colors.blue, // AppBar color for Light Mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // Using bodyLarge
      ),
      iconTheme: IconThemeData(color: Colors.black), // Black icons
    );
  }

  // Dark Mode Theme
  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey, // Main color for Dark Mode
      scaffoldBackgroundColor: Colors.black, // Scaffold background color
      appBarTheme: AppBarTheme(
        color: Colors.blueGrey, // AppBar color for Dark Mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Using bodyLarge
      ),
      iconTheme: IconThemeData(color: Colors.white), // White icons
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme() : _lightTheme(), // Choose theme based on settings
      home: const ProductivityHomePage(), // Main page
      routes: {
        '/settings': (context) => const SettingsPage(), // Route to Settings Page
        '/timeTracker': (context) => TimeTrackerPage(), // Route to Time Tracker Page
      },
    );
  }
}

class ProductivityHomePage extends StatelessWidget {
  const ProductivityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productivity App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Navigate to Settings Page
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView( // Wrap the entire body in a scroll view
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.yellow[100]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Halo, username",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sudahkah Anda Produktif Hari ini?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimerPage()),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Mulai Produktif"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Catatan dan Reminder Tugas",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tugas",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Dasar Pemrograman",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Deskripsi",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "• Mengerjakan soal OOP\n• Latihan UTS",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Deadline",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "29 November 2024",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                "Tambahkan Reminder Tugas atau Catatan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Learn more section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Bingung cari metode belajar yang efektif?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LearningMethodsPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Metode Belajar"),
                    ),
                    const SizedBox(height: 16),
                    // Add button to navigate to TimeTrackerPage
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/timeTracker');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Buka Time Tracker"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
