import 'dart:convert';
import 'package:final_year/View/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendence_report.dart'; // ✅ import attendance report screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Leave Update
  String? selectedReason;
  int leaveCount = 0;

  // Attendance (from QRManagerScreen records)
  int presentDays = 0;

  @override
  void initState() {
    super.initState();
    _loadData(); // 👈 Load saved data from SharedPreferences
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load leave count
    leaveCount = prefs.getInt("leaveCount") ?? 0;

    // Load attendance records from QRManagerScreen
    String? jsonData = prefs.getString("attendance_records");
    if (jsonData != null) {
      List<dynamic> decoded = jsonDecode(jsonData);
      presentDays = decoded.length; // ✅ count total attendance entries
    } else {
      presentDays = 0;
    }

    setState(() {});
  }

  Future<void> _saveLeave(String reason) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedReason = reason;
      leaveCount++;
    });
    await prefs.setInt("leaveCount", leaveCount);
  }

  void _showLeaveDialog() {
    List<String> reasons = ["Sick Leave", "Casual Leave", "Personal Work", "Other"];
    String? tempSelected = selectedReason;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Select Leave Reason"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: reasons.map((reason) {
              return RadioListTile<String>(
                title: Text(reason),
                value: reason,
                groupValue: tempSelected,
                onChanged: (value) {
                  setState(() {
                    tempSelected = value;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (tempSelected != null) {
                  _saveLeave(tempSelected!);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Leave saved for: $tempSelected")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.green,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Setting screen",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        // leading: const Icon(Icons.menu, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _topCard(
                  icon: Icons.time_to_leave,
                  text: "Leave update",
                  color: Colors.orange,
                  subtitle: "Leaves: $leaveCount",
                  onTap: _showLeaveDialog,
                ),
                _topCard(
                  icon: Icons.check_circle,
                  text: "Mark Attendance",
                  color: Colors.blue,
                  subtitle: "Present: $presentDays days",
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QRManagerScreen()),
                    );
                    _loadData(); // 👈 refresh count after QR scan
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reports list
            Expanded(
              child: ListView(
                children: [
                  ReportTile(
                    icon: Icons.assignment,
                    text: "Attendance Report",
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AttendanceReportScreen()),
                      );
                    },
                  ),
                  const ReportTile(
                      icon: Icons.summarize,
                      text: "Summary Report",
                      color: Colors.blue),
                  const ReportTile(
                      icon: Icons.insert_drive_file,
                      text: "All Generate Report",
                      color: Colors.teal),
                  const ReportTile(
                      icon: Icons.access_time,
                      text: "Overtime Report",
                      color: Colors.green),
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
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade800,
                blurRadius: 6,
                offset: const Offset(2, 2)),
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
                  fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap; // ✅ added callback

  const ReportTile({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 18, color: Colors.white70),
        onTap: onTap, // ✅ use passed callback
      ),
    );
  }
}
