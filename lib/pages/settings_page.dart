import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});  // Menggunakan super.key untuk konstruktor

  @override
  SettingsPageState createState() => SettingsPageState();  // Gantilah menjadi SettingsPageState
}

class SettingsPageState extends State<SettingsPage> {  // Mengganti _SettingsPageState menjadi SettingsPageState
  bool _isDarkMode = false;
  String _language = 'English';
  int _studyDuration = 1500; // Default: 25 minutes in seconds
  int _breakDuration = 300; // Default: 5 minutes in seconds

  // Memuat pengaturan dari SharedPreferences
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _language = prefs.getString('language') ?? 'English';
      _studyDuration = prefs.getInt('studyDuration') ?? 1500;
      _breakDuration = prefs.getInt('breakDuration') ?? 300;
    });
  }

  // Menyimpan pengaturan Dark Mode
  void _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value); // Menyimpan pengaturan Dark Mode
  }

  // Menyimpan pengaturan bahasa
  void _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  // Menyimpan pengaturan durasi timer
  void _saveTimerSettings(int studyDuration, int breakDuration) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('studyDuration', studyDuration);
    prefs.setInt('breakDuration', breakDuration);
  }

  // Reset pengaturan ke default
  void _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // Menghapus semua pengaturan yang disimpan
    setState(() {
      _isDarkMode = false;
      _language = 'English';
      _studyDuration = 1500; // Default: 25 menit
      _breakDuration = 300; // Default: 5 menit
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Memuat pengaturan saat halaman dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark/Light Mode Switch
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                  _saveDarkMode(value); // Menyimpan pengaturan Dark Mode
                });
              },
            ),

            // Language Selection
            ListTile(
              title: const Text("Language"),
              subtitle: Text(_language),
              onTap: () {
                _showLanguageDialog();
              },
            ),

            // Timer Settings
            ListTile(
              title: const Text("Study Duration"),
              subtitle: Text("${_studyDuration ~/ 60} minutes"),
              onTap: () {
                _showTimerDialog('study');
              },
            ),
            ListTile(
              title: const Text("Break Duration"),
              subtitle: Text("${_breakDuration ~/ 60} minutes"),
              onTap: () {
                _showTimerDialog('break');
              },
            ),

            // Reset Settings
            ListTile(
              title: const Text("Reset Settings"),
              onTap: _resetSettings,
            ),
          ],
        ),
      ),
    );
  }

  // Language Change Dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                onTap: () {
                  setState(() {
                    _language = 'English';
                    _saveLanguage('English');
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Bahasa Indonesia"),
                onTap: () {
                  setState(() {
                    _language = 'Bahasa Indonesia';
                    _saveLanguage('Bahasa Indonesia');
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Timer Duration Change Dialog
  void _showTimerDialog(String type) {
    int currentDuration = type == 'study' ? _studyDuration : _breakDuration;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set ${type == 'study' ? 'Study' : 'Break'} Duration"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Duration (minutes)",
                  hintText: "${currentDuration ~/ 60} minutes",
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      if (type == 'study') {
                        _studyDuration = int.parse(value) * 60;
                      } else {
                        _breakDuration = int.parse(value) * 60;
                      }
                    }
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _saveTimerSettings(_studyDuration, _breakDuration); // Menyimpan Timer Settings
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
