import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'learning_methods_page.dart'; // Tambahkan import untuk halaman metode belajar
import 'task_list_page.dart'; // Tambahkan import untuk halaman daftar tugas
import 'timer_page.dart';
import 'settings_page.dart'; // Tambahkan import untuk halaman SettingsPage

void main() {
  runApp(ProductivityApp());
}

class ProductivityApp extends StatefulWidget {
  const ProductivityApp({super.key});

  @override
  _ProductivityAppState createState() => _ProductivityAppState();
}

class _ProductivityAppState extends State<ProductivityApp> {
  bool _isDarkMode = false; // Variabel untuk menyimpan status Dark Mode

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Memuat pengaturan Dark Mode dari SharedPreferences
  }

  // Memuat pengaturan Dark Mode dari SharedPreferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Mendapatkan pengaturan Dark Mode
    });
  }

  // Tema Light Mode
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue, // Warna utama untuk Light Mode
      scaffoldBackgroundColor: Colors.white, // Latar belakang untuk Scaffold
      appBarTheme: AppBarTheme(
        color: Colors.blue, // Warna AppBar untuk Light Mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // Menggunakan bodyLarge
      ),
      iconTheme: IconThemeData(color: Colors.black), // Ikon berwarna hitam
    );
  }

  // Tema Dark Mode
  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey, // Warna utama untuk Dark Mode
      scaffoldBackgroundColor: Colors.black, // Latar belakang untuk Scaffold
      appBarTheme: AppBarTheme(
        color: Colors.blueGrey, // Warna AppBar untuk Dark Mode
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white), // Menggunakan bodyLarge
      ),
      iconTheme: IconThemeData(color: Colors.white), // Ikon berwarna putih
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme() : _lightTheme(), // Pilih tema berdasarkan pengaturan
      home: const ProductivityHomePage(), // Halaman utama
      routes: {
        '/settings': (context) => const SettingsPage(), // Rute ke halaman Settings
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
              Navigator.pushNamed(context, '/settings'); // Akses halaman Settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child: Text("Metode Belajar"),
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
