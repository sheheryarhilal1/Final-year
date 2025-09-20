import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 System navigation & status bar ko style karne ke liye
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // 👈 Bottom nav bar black
        systemNavigationBarIconBrightness: Brightness.light, // icons white
        statusBarColor: Colors.green, // 👈 Status bar color same as AppBar
        statusBarIconBrightness: Brightness.light, // Status bar icons white
      ),
    );

    return Scaffold(
      extendBody: true, // 👈 Fix: background ko bottom tak extend karega
      backgroundColor: Colors.black, // 👈 Pure screen background black
      appBar: AppBar(
        backgroundColor: Colors.green, // 👈 AppBar green
        elevation: 0,
        title: const Text(
          "Setting screen",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Employee List & Mark Attendance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _topCard(
                  icon: Icons.people,
                  text: "Teacher attendence list",
                  color: Colors.orange,
                ),
                _topCard(
                  icon: Icons.check_circle,
                  text: "Mark Attendance",
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reports
            Expanded(
              child: ListView(
                children: const [
                  ReportTile(
                    icon: Icons.assignment,
                    text: "Attendance Report",
                    color: Colors.red,
                  ),
                  ReportTile(
                    icon: Icons.summarize,
                    text: "Summary Report",
                    color: Colors.blue,
                  ),
                  ReportTile(
                    icon: Icons.insert_drive_file,
                    text: "All Generate Report",
                    color: Colors.teal,
                  ),
                  ReportTile(
                    icon: Icons.access_time,
                    text: "Overtime Report",
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topCard({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[900], // 👈 Dark background for cards
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade800, blurRadius: 6, offset: const Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.white, // 👈 Text white on black background
            ),
          )
        ],
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const ReportTile({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900], // 👈 Dark card
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white, // 👈 White text
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
        onTap: () {},
      ),
    );
  }
}
