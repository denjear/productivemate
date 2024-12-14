import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/learning_methods_page.dart'; // Import Learning Methods Page
import 'pages/task_list_page.dart'; // Import Task List Page
import 'pages/timer_page.dart';
import 'pages/settings_page.dart'; // Import Settings Page
import 'pages/time_tracker_page.dart'; // Import Time Tracker Page

void main() {
  runApp(ProductivityApp());
}

class ProductivityApp extends StatefulWidget {
  const ProductivityApp({super.key});

  @override
  _ProductivityAppState createState() => _ProductivityAppState();
}

class _ProductivityAppState extends State<ProductivityApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(), // Light Mode by default
      home: const ProductivityHomePage(), // Main page
      routes: {
        '/settings': (context) => const SettingsPage(), // Route to Settings Page
        '/timeTracker': (context) => TimeTrackerPage(), // Route to Time Tracker Page
      },
    );
  }

  // Light Mode Theme
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.yellow[100], // Main color for Light Mode
      scaffoldBackgroundColor: Colors.white, // Scaffold background color
      appBarTheme: AppBarTheme(
        color: Colors.yellow[100], // AppBar color for Light Mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // Using bodyLarge
      ),
      iconTheme: IconThemeData(color: Colors.black), // Black icons
    );
  }
}

class ProductivityHomePage extends StatefulWidget {
  const ProductivityHomePage({super.key});

  @override
  _ProductivityHomePageState createState() => _ProductivityHomePageState();
}

class _ProductivityHomePageState extends State<ProductivityHomePage> {
  String username = ''; // Variable to store the username
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load username from SharedPreferences when the app starts
  }

  // Load username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Username'; // Default to 'Username' if not set
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ProductiveMate"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              // Navigate to Settings Page and wait for the updated username
              final updatedUsername = await Navigator.pushNamed(context, '/settings');

              if (updatedUsername != null) {
                setState(() {
                  username = updatedUsername as String; // Update username with the returned value
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Text(
                      "Halo, $username", // Use the username here
                      style: const TextStyle(
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
                      icon: const Icon(Icons.alarm),
                      label: const Text("Mulai Produktif"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: const Text(
                  "Catatan dan Reminder Tugas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (details) {
                          _isPressed.value = true; // Set to true when pressed
                        },
                        onTapUp: (details) {
                          _isPressed.value = false; // Set to false when released
                        },
                        onTapCancel: () {
                          _isPressed.value = false; // Set to false if tap is canceled
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListPage(),
                            ),
                          );
                        },
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isPressed,
                          builder: (context, isPressed, child) {
                            return AnimatedScale(
                              scale: isPressed ? 0.9 : 1.0, // Apply animation for press effect
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeInOut,
                              child: Container(
                                width: 120,
                                height: 120,
                                padding: const EdgeInsets.all(8),
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
                                    const SizedBox(height: 12),
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
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  // Container untuk fitur "Metode Belajar"
                  Expanded(
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100], // Ubah warna menjadi [100]
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Bingung cari metode belajar yang efektif?",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 16),
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
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Membuat row tidak memakan ruang lebih
                                children: [
                                  Icon(
                                    Icons.book, // Ikon buku
                                    color: Colors.white,
                                    size: 20, // Ukuran ikon
                                  ),
                                  const SizedBox(width: 8), // Jarak antara ikon dan teks
                                  Flexible( // Membungkus teks dengan Flexible
                                    child: Text(
                                      "Metode Belajar",
                                      overflow: TextOverflow.ellipsis, // Menangani overflow jika terlalu panjang
                                      softWrap: true, // Membuat teks otomatis pindah ke baris baru jika terlalu panjang
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      maxLines: 2, // Membatasi maksimal dua baris
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Jarak antar container
                  // Container untuk fitur "Time Tracker"
                  Expanded(
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.yellow[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Lacak produktivitas Anda",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TimeTrackerPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.timer, // Ikon jam
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Time Tracker",
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 12),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
