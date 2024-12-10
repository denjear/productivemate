import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart'; // Install uuid package for unique IDs

class AddTaskPage extends StatefulWidget {
  final Function onTaskUpdated; // Callback for task update
  final Map<String, dynamic>? task; // Task to edit
  final bool isEditMode; // Determines add or edit mode

  const AddTaskPage({
    Key? key,
    required this.onTaskUpdated,
    this.task,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  DateTime? selectedDate;

  @override
void initState() {
  super.initState();
  if (widget.isEditMode && widget.task != null) {
    nameController.text = widget.task!['name'];
    descriptionController.text = widget.task!['description'];
    notesController.text = widget.task!['notes'];

    // Convert deadline String to DateTime
    selectedDate = widget.task!['deadline'] is String
        ? DateTime.parse(widget.task!['deadline'])
        : widget.task!['deadline'];
  }
}


  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      if (picked.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
        // Show error if date is in the past
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanggal tidak boleh di masa lalu")),
        );
      } else {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }

  void saveTask() async {
    if (nameController.text.isEmpty || selectedDate == null || descriptionController.text.isEmpty || notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Isi semua bagian")));
      return;
    }

    final newTask = {
      'id': widget.isEditMode && widget.task != null
          ? widget.task!['id'] // Use existing ID in Edit Mode
          : const Uuid().v4(), // Generate a new ID in Add Mode
      'name': nameController.text,
      'description': descriptionController.text,
      'notes': notesController.text,
      'deadline': selectedDate!.toIso8601String(),
    };

    final prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];

    if (widget.isEditMode && widget.task != null) {
      // Find the task by its unique ID
      final int index = tasks.indexWhere((taskJson) {
        final task = jsonDecode(taskJson);
        return task['id'] == widget.task!['id']; // Match by ID
      });

      if (index != -1) {
        tasks[index] = jsonEncode(newTask); // Update the task
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tugas tidak ditemukan")));
        return;
      }
    } else {
      // Add Mode: Append the new task
      tasks.add(jsonEncode(newTask));
    }

    // Save back to SharedPreferences
    await prefs.setStringList('tasks', tasks);

    widget.onTaskUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            widget.isEditMode ? "Edit Tugas" : "Tambah Tugas",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildInputSection("Nama Tugas", nameController),
            const SizedBox(height: 16),
            buildInputSection("Deskripsi Tugas", descriptionController, maxLines: 5),
            const SizedBox(height: 16),
            buildInputSection("Notes Pribadi", notesController, maxLines: 3),
            const SizedBox(height: 16),
            const Text("Deadline", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFFFF9C4), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null ? "Pilih Tanggal" : "${selectedDate?.toLocal()}".split(' ')[0],
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.black),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Batal", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: saveTask,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
                  child: const Text("Simpan", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const SizedBox(
        height: 16,
        child: Center(child: Divider(thickness: 2, color: Colors.black12, indent: 100, endIndent: 100)),
      ),
    );
  }

  Widget buildInputSection(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFFFF9C4), borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration.collapsed(hintText: null),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
