import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
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
    });
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
            Navigator.pop(context); // Close the overlay
            _navigateToEditTask(task); // Open edit task page
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
          onTaskUpdated: _loadTasks, // Refresh task list after edit
          task: task,
          isEditMode: true, // Pass edit mode flag
        ),
      ),
    );
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
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskPage(
                    onTaskUpdated: _loadTasks, // Refresh task list after adding a new task
                  ),
                ),
              );
            },
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
    );
  }
}
