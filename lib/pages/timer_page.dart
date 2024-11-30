import 'dart:async'; // Pastikan ini ada

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);  // Menambahkan super.key untuk konstruktor

  @override
  TimerPageState createState() => TimerPageState();  // Menggunakan TimerPageState yang publik
}

class TimerPageState extends State<TimerPage> {
  int remainingTime = 1500; // 25 minutes in seconds
  Timer? timer;
  bool isRunning = false;
  bool isBreak = false;
  List<String> sessionRecords = [];

  void startOrPauseTimer() {
    if (isRunning) {
      // Pause Timer
      timer?.cancel();
      setState(() {
        isRunning = false;
      });
    } else {
      // Start Timer
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            timer.cancel();
            isRunning = false;
            String sessionType = isBreak ? "Break" : "Session"; // Menggunakan sessionType
            sessionRecords.add(
                "$sessionType ${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}");
            isBreak = !isBreak;
            remainingTime = isBreak ? 300 : 1500; // Switch break or session
          }
        });
      });
    }
  }

  void resetTimer() {
    if (timer != null) timer!.cancel();
    setState(() {
      remainingTime = 1500; // Reset to 25 minutes
      isRunning = false;
    });
  }

  void startBreak() {
    if (timer != null) timer!.cancel();
    setState(() {
      remainingTime = 300; // 5 minutes in seconds
      isRunning = false;
      isBreak = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              "Pilih Teknik Belajarmu!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: "Teknik Pomodoro",
                  items: [
                    DropdownMenuItem(
                      value: "Teknik Pomodoro",
                      child: Text("Teknik Pomodoro"),
                    ),
                  ],
                  onChanged: (value) {},
                  dropdownColor: Colors.yellow[100],
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.black),
              ],
            ),
            SizedBox(height: 30),
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
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: resetTimer,
                  child: Text("RESET", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: startBreak,
                  child: Text("BREAK", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Record",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...sessionRecords.map((record) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      record,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "KEEP GOING!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }
}
