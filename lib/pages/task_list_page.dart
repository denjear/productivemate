import 'package:flutter/material.dart';
import 'dart:convert'; // Untuk encoding/decoding JSON
import 'package:shared_preferences/shared_preferences.dart';
import 'add_task_page.dart'; // Import AddTaskPage
import '../widgets/task_detail_overlay.dart'; // Import TaskDetailOverlay

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Map<String, dynamic>> tasks = [];
  bool isSortedByDeadline = true; // Flag to toggle sorting criteria

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasksJson = prefs.getStringList('tasks') ?? [];

    setState(() {
      tasks = tasksJson.map((taskJson) {
        final task = jsonDecode(taskJson) as Map<String, dynamic>;
        task['deadline'] = DateTime.parse(task['deadline']); // Parse deadline as DateTime
        return task;
      }).toList();

      _sortTasks(); // Sort the tasks after loading
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> tasksJson = tasks.map((task) => jsonEncode(task)).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index); // Menghapus task dari list
    });
    await _saveTasks(); // Menyimpan perubahan ke SharedPreferences
  }

  void _viewTaskDetails(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return TaskDetailOverlay(
          task: task,
          onEdit: () {
            Navigator.pop(context); // Tutup overlay
            _navigateToEditTask(task); // Buka halaman edit task
          },
          onDelete: () {
            Navigator.pop(context); // Tutup overlay
            _showDeleteConfirmation(task); // Tampilkan dialog konfirmasi penghapusan
          },
        );
      },
    );
  }

  void _navigateToEditTask(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskPage(
          onTaskUpdated: _loadTasks, // Refresh task list setelah edit
          task: task,
          isEditMode: true, // Pass edit mode flag
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> task) {
    int index = tasks.indexOf(task); // Mencari index task dalam list
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Tugas'),
          content: const Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteTask(index); // Hapus task dari list
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Sort tasks by deadline or name
  void _sortTasks() {
    setState(() {
      if (isSortedByDeadline) {
        tasks.sort((a, b) {
          final deadlineA = a['deadline'] as DateTime;
          final deadlineB = b['deadline'] as DateTime;
          return deadlineA.compareTo(deadlineB); // Sort by deadline ascending
        });
      } else {
        tasks.sort((a, b) {
          final nameA = a['name'] as String;
          final nameB = b['name'] as String;
          return nameA.compareTo(nameB); // Sort by name alphabetically
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "List Tugas dan Catatan",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (int value) {
              setState(() {
                isSortedByDeadline = value == 0; // 0 -> Sort by deadline, 1 -> Sort by name
                _sortTasks(); // Sort tasks based on the selected option
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Urutkan berdasarkan Deadline'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Urutkan berdasarkan Nama'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final deadline = task['deadline'] as DateTime;

            return GestureDetector(
              onTap: () => _viewTaskDetails(task),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      task['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Deadline: ${deadline.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(
                onTaskUpdated: _loadTasks, // Refresh task list setelah menambahkan task baru
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.yellow[100],
      ),
    );
  }
}
