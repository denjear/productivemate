import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter/services.dart'; // Import SystemNavigator

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Load username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _usernameController.text = prefs.getString('username') ?? ''; // Load saved username
  }

  // Save username to SharedPreferences
  Future<void> _saveUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text); // Save the new username
    Navigator.pop(context, _usernameController.text); // Return the updated username to the homepage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveUsername(); // Save the username to SharedPreferences and return to homepage
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 32),
            // Exit button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop(); // Exit the app
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Warna latar belakang merah
                  foregroundColor: Colors.white, // Warna teks putih
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30), // Tambahkan horizontal padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Membuat sudut tombol melengkung
                  ),
                ),
                child: const Text(
                  'Exit App',
                  style: TextStyle(fontSize: 16), // Ukuran teks
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}