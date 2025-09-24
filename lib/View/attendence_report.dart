import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  List<Map<String, dynamic>> attendanceRecords = [];

  int leaveCount = 0;
  int totalDays = 30; // Example working days

  Map<String, int> summary = {"daily": 0, "weekly": 0, "monthly": 0};

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("attendance_records");

    if (jsonData != null) {
      List decoded = jsonDecode(jsonData);
      attendanceRecords =
          decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    leaveCount = prefs.getInt("leaveCount") ?? 0;

    _processAttendance();
  }

  void _processAttendance() {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);

    int daily = 0, weekly = 0, monthly = 0;

    Set<String> uniqueDays = {};

    for (var record in attendanceRecords) {
      DateTime date = DateTime.parse(record['timeIn']);
      final recordDate = DateTime(date.year, date.month, date.day);

      if (DateFormat('yyyy-MM-dd').format(recordDate) == today) daily++;
      if (now.difference(recordDate).inDays < 7) weekly++;
      if (now.month == recordDate.month && now.year == recordDate.year) monthly++;

      uniqueDays.add(DateFormat('yyyy-MM-dd').format(recordDate));
    }

    summary = {"daily": daily, "weekly": weekly, "monthly": monthly};

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Attendance Report"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              color: Colors.green[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryColumn("Daily", summary["daily"] ?? 0),
                    _summaryColumn("Weekly", summary["weekly"] ?? 0),
                    _summaryColumn("Monthly", summary["monthly"] ?? 0),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Early Leaves
            Text("📌 Early Leaves", style: _titleStyle()),
            Text(
              "Total Early Leaves: $leaveCount",
              style: const TextStyle(color: Colors.orange, fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Bar Chart
            Text("📊 Attendance Overview", style: _titleStyle()),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("Daily",
                                  style: TextStyle(color: Colors.white));
                            case 1:
                              return const Text("Weekly",
                                  style: TextStyle(color: Colors.white));
                            case 2:
                              return const Text("Monthly",
                                  style: TextStyle(color: Colors.white));
                            case 3:
                              return const Text("Leaves",
                                  style: TextStyle(color: Colors.white));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: summary["daily"]?.toDouble() ?? 0,
                          color: Colors.green,
                          width: 30,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: summary["weekly"]?.toDouble() ?? 0,
                          color: Colors.blue,
                          width: 30,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: summary["monthly"]?.toDouble() ?? 0,
                          color: Colors.purple,
                          width: 30,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: leaveCount.toDouble(),
                          color: Colors.orange,
                          width: 30,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryColumn(String title, int value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        Text("$value",
            style: const TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }

  TextStyle _titleStyle() => const TextStyle(
      color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold);
}
