import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic> taskData;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
    required this.taskData,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Map<String, dynamic> taskData;

  @override
  void initState() {
    super.initState();
    taskData = Map<String, dynamic>.from(widget.taskData);
  }

  Future<void> pickDateTime() async {
    final initialDate =
        (taskData['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime != null) {
      final fullDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        taskData['dateTime'] = Timestamp.fromDate(fullDateTime);
      });
    }
  }

  Future<void> pickCategory() async {
    final categories = [
      {
        'label': 'Grocery',
        'icon': Icons.shopping_cart,
        'color': Colors.greenAccent,
      },
      {'label': 'Work', 'icon': Icons.work_outline, 'color': Colors.orange},
      {'label': 'Sport', 'icon': Icons.fitness_center, 'color': Colors.cyan},
      {
        'label': 'Design',
        'icon': Icons.design_services,
        'color': Colors.tealAccent,
      },
      {'label': 'University', 'icon': Icons.school, 'color': Colors.blueAccent},
      {
        'label': 'Social',
        'icon': Icons.people_outline,
        'color': Colors.pinkAccent,
      },
      {
        'label': 'Music',
        'icon': Icons.music_note,
        'color': Colors.purpleAccent,
      },
      {
        'label': 'Health',
        'icon': Icons.health_and_safety,
        'color': Colors.deepPurple,
      },
      {'label': 'Movie', 'icon': Icons.movie, 'color': Colors.lightBlueAccent},
    ];

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.55,
              maxWidth: 320,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      shrinkWrap: true,
                      childAspectRatio: 0.85,
                      children:
                          categories.map((item) {
                            final isSelected =
                                taskData['category'] == item['label'];
                            return GestureDetector(
                              onTap:
                                  () => Navigator.pop(
                                    context,
                                    item['label'] as String,
                                  ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? const Color(0xFF7A5DF5)
                                          : item['color'] as Color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item['icon'] as IconData,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['label'] as String,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        taskData['category'] = result;
      });
    }
  }

  Future<void> pickPriority() async {
    int selected = taskData['priority'] ?? 1;
    final result = await showDialog<int>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Select Priority',
              style: TextStyle(color: Colors.white),
            ),
            content: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(10, (i) {
                final number = i + 1;
                return GestureDetector(
                  onTap: () => Navigator.pop(context, number),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color:
                          selected == number
                              ? const Color(0xFF7A5DF5)
                              : const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.flag_outlined, color: Colors.white),
                        Text(
                          '$number',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
    );

    if (result != null) {
      setState(() {
        taskData['priority'] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Timestamp? timestamp = taskData['dateTime'];
    final String formattedDate =
        timestamp != null
            ? DateFormat('EEE, d MMM yyyy – HH:mm').format(timestamp.toDate())
            : 'No time set';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      taskData['title'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _showEditDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                taskData['description'] ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              _buildDetailItem(
                Icons.access_time,
                "Task Time :",
                formattedDate,
                onTap: pickDateTime,
              ),
              _buildDetailItem(
                Icons.local_offer,
                "Task Category :",
                taskData['category'] ?? '-',
                onTap: pickCategory,
              ),
              _buildDetailItem(
                Icons.flag,
                "Task Priority :",
                "Priority ${taskData['priority'] ?? 1}",
                onTap: pickPriority,
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => _showDeleteConfirmation(context),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "Delete Task",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(widget.taskId)
                        .update(taskData);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Perubahan disimpan")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A5DF5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Edit Task",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(value, style: const TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: taskData['title']);
    final descController = TextEditingController(text: taskData['description']);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Edit Task Title',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black,
                    hintText: 'Title',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black,
                    hintText: 'Description',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedTitle = titleController.text.trim();
                  final updatedDesc = descController.text.trim();
                  if (updatedTitle.isEmpty) return;
                  setState(() {
                    taskData['title'] = updatedTitle;
                    taskData['description'] = updatedDesc;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5DF5),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Hapus Tugas?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Apakah kamu yakin ingin menghapus tugas ini?\nTindakan ini tidak bisa dibatalkan.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(widget.taskId)
                      .delete();
                  if (context.mounted) {
                    Navigator.pop(context); // Tutup dialog
                    Navigator.pop(context); // Kembali ke home
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task berhasil dihapus")),
                    );
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
    );
  }
}
