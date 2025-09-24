import 'dart:convert';
import 'package:final_year/View/Profile_screen.dart';
import 'package:final_year/View/Setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/custom_bottom nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.black, // ✅ Background black
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green, // ✅ AppBar green
        foregroundColor: Colors.white, // ✅ Text/icons white
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    home: QRManagerScreen(),
  ));
}

// Global attendance list (local storage only)
List<Map<String, dynamic>> localAttendance = [];

Future<void> _saveData() async {
  final prefs = await SharedPreferences.getInstance();
  String jsonData = jsonEncode(localAttendance);
  await prefs.setString("attendance_records", jsonData);
}

class QRManagerScreen extends StatefulWidget {
  @override
  State<QRManagerScreen> createState() => _QRManagerScreenState();
}

class _QRManagerScreenState extends State<QRManagerScreen> {
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("attendance_records");
    if (jsonData != null) {
      localAttendance = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
    } else {
      localAttendance = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  // 🔹 Helper: Calculate Daily / Weekly / Monthly Summary
  Map<String, int> calculateSummary() {
    int daily = 0, weekly = 0, monthly = 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var record in localAttendance) {
      if (record["timeIn"] == null || record["timeIn"].isEmpty) continue;

      DateTime date = DateTime.parse(record["timeIn"]);
      final recordDate = DateTime(date.year, date.month, date.day);

      // Daily
      if (recordDate == today) {
        daily++;
      }

      // Weekly (last 7 days)
      if (now.difference(recordDate).inDays < 7) {
        weekly++;
      }

      // Monthly (same month & year)
      if (recordDate.month == now.month && recordDate.year == now.year) {
        monthly++;
      }
    }

    return {
      "daily": daily,
      "weekly": weekly,
      "monthly": monthly,
    };
  }

  Future<void> showPopup(BuildContext context, Map<String, dynamic> data,
      {int? existingIndex}) async {
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    String teacher = email.contains('@') ? email.split('@')[0] : email;

    final prefs = await SharedPreferences.getInstance();
    String password = prefs.getString("user_password") ?? "";

    String classId = existingIndex == null
        ? (data["classId"] ?? "")
        : localAttendance[existingIndex]["classId"];

    TextEditingController classIdController =
        TextEditingController(text: classId);

    String timeIn = existingIndex == null
        ? ""
        : localAttendance[existingIndex]["timeIn"] ?? "";
    String outTime = existingIndex == null
        ? ""
        : localAttendance[existingIndex]["outTime"] ?? "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('QR Details', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "👨‍🏫 Teacher"),
              controller: TextEditingController(text: teacher),
              readOnly: true,
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "🔐 Password"),
              controller: TextEditingController(
                text: "*" * password.length,
              ),
              readOnly: true,
            ),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: classIdController,
              readOnly: existingIndex != null,
              decoration: InputDecoration(
                labelText: existingIndex == null
                    ? "🏷️ Class ID (Editable)"
                    : "🏷️ Class ID",
              ),
            ),
            const SizedBox(height: 10),
            Text("🆔 Token: ${data["token"] ?? 'N/A'}",
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            Text("⏰ Time In: ${timeIn.isNotEmpty ? timeIn : 'Not marked yet'}",
                style: const TextStyle(color: Colors.white)),
            Text("🏁 Out Time: ${outTime.isNotEmpty ? outTime : 'Not marked yet'}",
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          if (existingIndex == null)
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Mark Time In"),
              onPressed: () async {
                final newEntry = {
                  "teacher": teacher,
                  "password": password,
                  "classId": classIdController.text,
                  "timeIn": DateTime.now().toString(),
                  "outTime": "",
                  "token": data["token"] ?? "N/A",
                };

                setState(() {
                  localAttendance.add(newEntry);
                });
                await _saveData();
                Navigator.pop(context);
              },
            )
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Mark Time Out"),
              onPressed: () async {
                setState(() {
                  localAttendance[existingIndex]["outTime"] =
                      DateTime.now().toString();
                });
                await _saveData();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  void scanAndShowPopup({int? editIndex}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text("📷 Scan QR"),
          ),
          body: MobileScanner(
            onDetect: (capture) {
              if (capture.barcodes.isEmpty) return;
              final barcode = capture.barcodes.first;
              final String? data = barcode.rawValue;

              if (data != null && data.trim().isNotEmpty) {
                try {
                  final decoded = jsonDecode(data);
                  Navigator.pop(context);
                  showPopup(context, decoded, existingIndex: editIndex);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid QR Data")),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _screens() => [
        _buildScreenWithAppBar("Attendance System", _buildAttendanceList()),
        _buildScreenWithAppBar("Report", const Center(child: Text("Daily Report"))),
        _buildScreenWithAppBar("QR Scan", const Center(child: Text("QR Scan Screen"))),
        ProfileScreen(),
        HomeScreen()
      ];

  Widget _buildScreenWithAppBar(String title, Widget child) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(title),
      ),
      body: child,
    );
  }

  Widget _buildAttendanceList() {
    if (localAttendance.isEmpty) {
      return const Center(
        child: Text(
          "No records yet. Scan a QR to add.",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      );
    }

    final summary = calculateSummary();

    return Column(
      children: [
        // 🔹 Summary Card
        Card(
          color: Colors.green[900],
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Daily", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("${summary["daily"]}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    const Text("Weekly", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("${summary["weekly"]}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    const Text("Monthly", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("${summary["monthly"]}", style: const TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 🔹 Attendance Records List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: localAttendance.length,
            itemBuilder: (context, index) {
              final entry = localAttendance[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.greenAccent),
                            onPressed: () {
                              scanAndShowPopup(editIndex: index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              setState(() {
                                localAttendance.removeAt(index);
                                _saveData();
                              });
                            },
                          ),
                        ],
                      ),
                      Text("👨‍🏫 Teacher: ${entry['teacher']}", style: const TextStyle(color: Colors.white)),
                      Text("🏷️ Class ID: ${entry['classId']}", style: const TextStyle(color: Colors.white)),
                      Text("⏰ Time In: ${entry['timeIn']}", style: const TextStyle(color: Colors.white)),
                      Text(
                        "🏁 Out Time: ${entry['outTime'] != null && entry['outTime'].isNotEmpty ? entry['outTime'] : 'Not marked yet'}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens()[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => scanAndShowPopup(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan QR"),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
