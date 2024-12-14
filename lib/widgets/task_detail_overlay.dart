import 'package:flutter/material.dart';

class TaskDetailOverlay extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onEdit;
  final VoidCallback onDelete; // Menambahkan parameter onDelete

  const TaskDetailOverlay({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete, // Menambahkan konstruktor untuk parameter onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime deadline = task['deadline'] as DateTime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back", style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              const Text(
                "Detail",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              TextButton(
                onPressed: onEdit,
                child: const Text("Edit", style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.black12),
          const SizedBox(height: 16),
          buildDetailSection("Nama Tugas", task['name']),
          buildDetailSection("Deadline", deadline.toLocal().toString().split(' ')[0]),
          buildDetailSection("Deskripsi", task['description']),
          buildDetailSection("Note", task['notes']),
          const SizedBox(height: 20),
          // Menambahkan tombol Delete
          Center(
            child: ElevatedButton(
              onPressed: onDelete, // Menjalankan fungsi onDelete
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna latar belakang tombol
                foregroundColor: Colors.white, // Warna tulisan tombol
              ),
              child: const Text("Delete Task"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}