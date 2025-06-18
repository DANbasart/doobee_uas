import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Settings",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          _buildSettingsTile(Icons.color_lens_outlined, "Change app color"),
          _buildSettingsTile(Icons.text_fields, "Change app typography"),
          _buildSettingsTile(Icons.language, "Change app language"),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Import",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          _buildSettingsTile(Icons.calendar_today_outlined, "Import from Google calendar"),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: () {
        // TODO: Implement navigation or functionality
      },
    );
  }
}
