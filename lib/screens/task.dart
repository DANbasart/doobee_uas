import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int selectedPriority = 1;

  String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt); // Contoh: 08:30 AM
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> pickPriority() async {
    int? result = await showDialog<int>(
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
              children: List.generate(10, (index) {
                int number = index + 1;
                return InkWell(
                  onTap: () => Navigator.pop(context, number),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color:
                          selectedPriority == number
                              ? const Color(0xFF7A5DF5)
                              : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
    );

    if (result != null) {
      setState(() {
        selectedPriority = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Task', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Task Title',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white70),
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  selectedDate != null
                      ? formatDate(selectedDate!)
                      : 'Pick a date',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: pickTime,
                  icon: const Icon(Icons.access_time, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  selectedTime != null
                      ? formatTime(selectedTime!)
                      : 'Pick a time',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: pickPriority,
                  icon: const Icon(Icons.priority_high, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  'Priority: $selectedPriority',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // Kirim atau simpan task
                Navigator.pop(context); // balik ke home
              },
              icon: const Icon(Icons.check),
              label: const Text('Save Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5DF5),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
