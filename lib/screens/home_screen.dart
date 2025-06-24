import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doobee_uas/screens/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Map<String, Map<String, dynamic>> categoryMap = const {
    'Grocery': {'icon': Icons.shopping_cart, 'color': Colors.greenAccent},
    'Work': {'icon': Icons.work_outline, 'color': Colors.orange},
    'Sport': {'icon': Icons.fitness_center, 'color': Colors.cyan},
    'Design': {'icon': Icons.design_services, 'color': Colors.tealAccent},
    'University': {'icon': Icons.school, 'color': Colors.blueAccent},
    'Social': {'icon': Icons.people_outline, 'color': Colors.pinkAccent},
    'Music': {'icon': Icons.music_note, 'color': Colors.purpleAccent},
    'Health': {'icon': Icons.health_and_safety, 'color': Colors.deepPurple},
    'Movie': {'icon': Icons.movie, 'color': Colors.lightBlueAccent},
  };

  Stream<QuerySnapshot> streamTasks() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('userEmail', isEqualTo: user.email)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text("Beranda", style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(backgroundColor: Colors.white, radius: 14),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: streamTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/index.png', height: 200),
                  const SizedBox(height: 32),
                  const Text(
                    "Apa yang ingin Anda lakukan hari ini?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Klik + untuk menambahkan tugas Anda",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final title = data['title'] ?? '-';
              final description = data['description'] ?? '';
              final category = data['category'] as String?;
              final priority = data['priority'] ?? 1;

              DateTime? dateTime;
              if (data['dateTime'] is Timestamp) {
                dateTime = (data['dateTime'] as Timestamp).toDate();
              } else if (data['dateTime'] is String) {
                dateTime = DateTime.tryParse(data['dateTime']);
              }

              final isToday =
                  dateTime != null &&
                  DateFormat('yyyy-MM-dd').format(dateTime) ==
                      DateFormat('yyyy-MM-dd').format(DateTime.now());

              final timeText =
                  dateTime != null
                      ? isToday
                          ? "Today At ${DateFormat('HH:mm').format(dateTime)}"
                          : DateFormat('EEE, d MMM - HH:mm').format(dateTime)
                      : '';

              final categoryData =
                  category != null ? categoryMap[category] : null;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (timeText.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              timeText,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (categoryData != null)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryData['color'],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              categoryData['icon'],
                              size: 16,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category ?? '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flag_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            priority.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9B8CFF),
        elevation: 6,
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const TaskPopup(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 35, 35, 35),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 8,
        child: SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                BottomNavItem(icon: Icons.home, label: 'Beranda'),
                BottomNavItem(icon: Icons.calendar_today, label: 'Kalender'),
                SizedBox(width: 40),
                BottomNavItem(icon: Icons.timer, label: 'Fokus'),
                BottomNavItem(icon: Icons.person, label: 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const BottomNavItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
