import 'dart:async'; // Pastikan ini ada

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  TimerPageState createState() => TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  int remainingTime = 600; // Default: 10 minutes in seconds
  Timer? timer;
  bool isRunning = false;
  bool isBreak = false;
  List<String> sessionRecords = [];
  String selectedTechnique = "The 10-Minute Rule"; // Default selected technique

  final Map<String, int> techniqueDurations = {
    "Pomodoro Technique": 1500, // 25 minutes
    "The 10-Minute Rule": 600, // 10 minutes
    "Work-Rest-Work": 900, // 15 minutes
    "52/17 Method": 3120, // 52 minutes
    "Ultradian Rhythm Technique": 5400, // 90 minutes
  };

  final Map<String, int> breakDurations = {
    "Pomodoro Technique": 300, // 5 minutes
    "The 10-Minute Rule": 0, // No Break
    "Work-Rest-Work": 300, // 5 minutes
    "52/17 Method": 1020, // 17 minutes
    "Ultradian Rhythm Technique": 1200, // 20 minutes
  };

  final Map<String, String> techniqueDescriptions = {
    "The 10-Minute Rule": "Teknik ini menyarankan kamu untuk mulai bekerja selama hanya 10 menit. Jika setelah 10 menit kamu merasa nyaman dan fokus, lanjutkan pekerjaan. Tujuannya adalah untuk mengatasi rasa malas dengan memulai dalam waktu yang sangat singkat.",
    "Work-Rest-Work": "Teknik ini melibatkan siklus kerja yang lebih singkat. Kamu bekerja selama 15 menit, kemudian istirahat selama 5 menit. Siklus ini diulang beberapa kali untuk menjaga fokus dan menghindari kelelahan.",
    "Ultradian Rhythm Technique": "Teknik ini berfokus pada ritme alami tubuh, di mana kamu bekerja selama 90-120 menit penuh, kemudian beristirahat selama 20-30 menit. Siklus ini mengikuti ritme biologis tubuh untuk memaksimalkan energi dan produktivitas.",
    "52/17 Method": "Dalam teknik ini, kamu bekerja selama 52 menit, diikuti dengan istirahat selama 17 menit. Penelitian menunjukkan bahwa waktu bekerja yang ideal adalah 52 menit, dan sesi istirahat sebaiknya cukup lama untuk mengembalikan energi.",
    "Pomodoro Technique": "Teknik ini melibatkan sesi kerja selama 25 menit, disebut satu Pomodoro, diikuti dengan istirahat selama 5 menit. Setelah empat Pomodoro, kamu dapat mengambil istirahat lebih lama, sekitar 15-30 menit. Teknik ini dirancang untuk menjaga fokus dan menghindari kelelahan.",
  };

  void showTechniqueInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(selectedTechnique),
          content: Text(techniqueDescriptions[selectedTechnique]!),
          actions: [
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startOrPauseTimer() {
  if (isRunning) {
    // Pause Timer
    timer?.cancel();
    int elapsedTime = (isBreak
        ? breakDurations[selectedTechnique]! - remainingTime
        : techniqueDurations[selectedTechnique]! - remainingTime);

    setState(() {
      isRunning = false;
      String sessionType = isBreak ? "Break" : "Study";
      sessionRecords.add("$sessionType paused: ${(elapsedTime ~/ 60).toString().padLeft(2, '0')} menit ${(elapsedTime % 60).toString().padLeft(2, '0')} detik");
    });
  } else {
    // Start Timer
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          isRunning = false;
          String sessionType = isBreak ? "Break" : "Session";
          int elapsedTime = isBreak
              ? breakDurations[selectedTechnique]!
              : techniqueDurations[selectedTechnique]!;
          sessionRecords.add("$sessionType selesai: ${(elapsedTime ~/ 60).toString().padLeft(2, '0')} menit ${(elapsedTime % 60).toString().padLeft(2, '0')} detik");
          isBreak = !isBreak; // Toggle between break and study session
          remainingTime = isBreak
              ? breakDurations[selectedTechnique]!
              : techniqueDurations[selectedTechnique]!; // Set remaining time for the next session
        }
      });
    });
  }
}

  void resetTimer() {
    if (timer != null) timer!.cancel();
    setState(() {
      remainingTime = techniqueDurations[selectedTechnique]!; // Reset to current technique's time
      isRunning = false;
      isBreak = false; // Reset to not break
    });
  }

  void changeTechnique(String newTechnique) {
    setState(() {
      selectedTechnique = newTechnique;
      remainingTime = techniqueDurations[selectedTechnique]!; // Reset to new technique's time
      isRunning = false; // Ensure timer is not running
      isBreak = false; // Set to study session
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Text(
              "Pilih Teknik Belajarmu!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedTechnique,
                  items: techniqueDurations.keys.map((String technique) {
                    return DropdownMenuItem<String>(
                      value: technique,
                      child: Text(technique),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      changeTechnique(value);
                    }
                  },
                  dropdownColor: Colors.yellow[100],
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showTechniqueInfo(context); //panggil fungsi untuk menampilkan dialog
                  },
                  child: const Icon(Icons.info_outline, color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: startOrPauseTimer,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 8),
                ),
                child: Center(
                  child: Text(
                    "${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: resetTimer,
                  child: const Text("RESET", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: startOrPauseTimer,
                  child: Text(isRunning ? "PAUSE" : "START", style: const TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (isBreak) {
                      // Jika sedang break, kembali ke sesi study
                      setState(() {
                        isBreak = false;
                        remainingTime = techniqueDurations[selectedTechnique]!; // Atur waktu ke sesi study
                        isRunning = false; // Jangan langsung start, tetap manual
                        if (timer != null) timer!.cancel(); // Hentikan timer jika aktif
                      });
                    } else {
                      // Mulai break
                      if (breakDurations[selectedTechnique]! > 0) {
                        startBreak();
                      }
                    }
                  },
                  child: Text(
                    isBreak ? "TO STUDY" : "BREAK", // Ubah label berdasarkan mode saat ini
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Record",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sessionRecords.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        sessionRecords[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SizedBox(), // Placeholder for spacing
            ),
          ],
        ),
      ),
    );
  }
  
  void startBreak() {
  if (timer != null) timer!.cancel();
  setState(() {
    remainingTime = breakDurations[selectedTechnique]!; // Set to break duration
    isRunning = true;
    isBreak = true; // Set to break session
  });

  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        timer.cancel();
        isRunning = false;
        sessionRecords.add("Break selesai: ${(breakDurations[selectedTechnique]! ~/ 60).toString().padLeft(2, '0')} menit");
      }
    });
  });
}
}