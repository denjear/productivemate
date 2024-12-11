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
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 120, // Lebar container
                          height: 120, // Tinggi container, sama dengan lebar agar berbentuk persegi
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
                              const SizedBox(height: 12), // Perkecil jarak antara ikon dan teks
                              Text(
                                "Tambahkan Reminder Tugas atau Catatan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14, // Perkecil ukuran font agar lebih proporsional
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
                              "Yuk, catat produktivitasmu sehari-hari!",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 16),
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Menyesuaikan ukuran row agar tidak overflow
                                children: [
                                  Icon(
                                    Icons.access_time, // Ikon yang berkaitan dengan aktivitas
                                    color: Colors.white,
                                    size: 20, // Ukuran ikon
                                  ),
                                  const SizedBox(width: 8), // Memberi jarak antara ikon dan teks
                                  Flexible( // Membungkus Text dengan Flexible untuk memungkinkan teks pindah baris
                                    child: Text(
                                      "Activity Tracker",
                                      style: TextStyle(
                                        fontSize: 12, // Ukuran font yang lebih kecil
                                      ),
                                      overflow: TextOverflow.ellipsis, // Menambahkan ellipsis jika diperlukan
                                      softWrap: true, // Membuat teks otomatis pindah ke baris baru jika diperlukan
                                      maxLines: 2, // Membatasi maksimal dua baris
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
