import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskPopup extends StatefulWidget {
  const TaskPopup({super.key});

  @override
  State<TaskPopup> createState() => _TaskPopupState();
}

class _TaskPopupState extends State<TaskPopup> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  DateTime? selectedDateTime;
  int selectedPriority = 1;
  String? selectedCategory;

  String formatDateTime(DateTime dateTime) {
    return DateFormat('EEE, d MMM yyyy - hh:mm a').format(dateTime);
  }

  Future<void> pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final fullDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() => selectedDateTime = fullDateTime);
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
      builder:
          (context) => Dialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.55,
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
                    Expanded(
                      child: GridView.builder(
                        itemCount: categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (context, index) {
                          final item = categories[index];
                          final isSelected = selectedCategory == item['label'];
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
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    if (result != null) {
      setState(() => selectedCategory = result);
    }
  }

  Future<void> pickPriority() async {
    int tempSelectedPriority = selectedPriority;

    final result = await showDialog<int>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Task Priority',
              style: TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(
              builder:
                  (context, setStateDialog) => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(10, (index) {
                      final number = index + 1;
                      final isSelected = tempSelectedPriority == number;
                      return GestureDetector(
                        onTap:
                            () => setStateDialog(
                              () => tempSelectedPriority = number,
                            ),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF7A5DF5)
                                    : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                              ),
                              Text(
                                '$number',
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.white60,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A5DF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () => Navigator.pop(context, tempSelectedPriority),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null) {
      setState(() => selectedPriority = result);
    }
  }

  void saveTask() async {
    final title = titleController.text.trim();
    final desc = descController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (title.isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('tasks').add({
      'title': title,
      'description': desc,
      'dateTime':
          selectedDateTime != null
              ? Timestamp.fromDate(selectedDateTime!)
              : null,
      'category': selectedCategory,
      'priority': selectedPriority,
      'userEmail': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Name Task',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: pickDateTime,
                  icon: const Icon(Icons.access_time, color: Colors.white),
                  tooltip: 'Pilih Tanggal & Waktu',
                ),
                IconButton(
                  onPressed: pickCategory,
                  icon: const Icon(
                    Icons.local_offer_outlined,
                    color: Colors.white,
                  ),
                  tooltip: 'Pilih Kategori',
                ),
                IconButton(
                  onPressed: pickPriority,
                  icon: const Icon(Icons.flag_outlined, color: Colors.white),
                  tooltip: 'Pilih Prioritas',
                ),
                const Spacer(),
                IconButton(
                  onPressed: saveTask,
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Color(0xFF7A5DF5),
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
