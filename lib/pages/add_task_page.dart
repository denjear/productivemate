import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill example data
    nameController.text = "";
    deadlineController.text = "";
    descriptionController.text =
        "";
    notesController.text =
        "";
  }

  @override
  void dispose() {
    nameController.dispose();
    deadlineController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void saveTask() {
    // Handle save action
    if (nameController.text.isEmpty ||
        deadlineController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        notesController.text.isEmpty) {
      // Show a SnackBar if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua bagian")),
      );
    } else {
      // Proceed with saving the task (or just go back for now)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Tambah Tugas",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
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
            buildInputSection("Deadline", deadlineController),
            const SizedBox(height: 16),
            buildInputSection("Deskripsi Tugas", descriptionController, maxLines: 5),
            const SizedBox(height: 16),
            buildInputSection("Notes Pribadi", notesController, maxLines: 3),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cancel and go back
                  },
                  child: const Text(
                    "Batal",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: saveTask, // Handle save action
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const SizedBox(
        height: 16,
        child: Center(
          child: Divider(
            thickness: 2,
            color: Colors.black12,
            indent: 100,
            endIndent: 100,
          ),
        ),
      ),
    );
  }

  Widget buildInputSection(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration.collapsed(hintText: null),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            onTap: () {
              // Clear the field when clicked
              if (controller.text.isNotEmpty) {
                controller.clear();
              }
            },
          ),
        ),
      ],
    );
  }
}
