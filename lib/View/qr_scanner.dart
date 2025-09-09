import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/singup_controler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRManagerScreen(),
  ));
}

// Global attendance list
List<Map<String, dynamic>> localAttendance = [];

/// 💾 Save data permanently
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
  @override
  void initState() {
    super.initState();
    _loadData(); // app khulte hi data load hoga
  }

  /// 🔄 Load saved data
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("attendance_records");
    if (jsonData != null) {
      setState(() {
        localAttendance =
            List<Map<String, dynamic>>.from(jsonDecode(jsonData));
      });
    }
  }

  /// 📌 Popup for marking Time In / Out
  Future<void> showPopup(BuildContext context, Map<String, dynamic> data,
      {int? existingIndex}) async {
    String teacher = SignupController.savedUsername;
    String password = SignupController.savedPassword;

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
        title: Text('QR Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "👨‍🏫 Teacher"),
              controller: TextEditingController(text: teacher),
              readOnly: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: "🔐 Password"),
              controller: TextEditingController(text: password),
              readOnly: true,
              obscureText: true,
            ),
            TextField(
              controller: classIdController,
              readOnly: existingIndex != null,
              decoration: InputDecoration(
                labelText: existingIndex == null
                    ? "🏷️ Class ID (Editable)"
                    : "🏷️ Class ID",
              ),
            ),
            SizedBox(height: 10),
            Text("⏰ Time In: ${timeIn.isNotEmpty ? timeIn : 'Not marked yet'}"),
            Text("🏁 Out Time: ${outTime.isNotEmpty ? outTime : 'Not marked yet'}"),
          ],
        ),
        actions: [
          if (existingIndex == null)
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Mark Time In"),
              onPressed: () async {
                final newEntry = {
                  "teacher": teacher,
                  "password": password,
                  "classId": classIdController.text,
                  "timeIn": DateTime.now().toString(),
                  "outTime": "",
                };
                localAttendance.add(newEntry);
                await _saveData();
                Navigator.pop(context);
                setState(() {});
              },
            )
          else
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text("Mark Time Out"),
              onPressed: () async {
                localAttendance[existingIndex]["outTime"] =
                    DateTime.now().toString();
                await _saveData();
                Navigator.pop(context);
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  /// 📷 QR Scan and show popup
  void scanAndShowPopup({int? editIndex}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text("📷 Scan QR")),
          body: MobileScanner(
            onDetect: (capture) {
              final String? data = capture.barcodes.first.rawValue;
              if (data != null) {
                try {
                  final decoded = jsonDecode(data);
                  Navigator.pop(context);
                  showPopup(context, decoded, existingIndex: editIndex);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid QR Data")),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance System"),
        backgroundColor: Colors.greenAccent,
      ),
      body: localAttendance.isEmpty
          ? Center(
              child: Text(
                "No records yet. Scan a QR to add.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: localAttendance.length,
              itemBuilder: (context, index) {
                final entry = localAttendance[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                scanAndShowPopup(editIndex: index);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                scanAndShowPopup(editIndex: index);
                              },
                            ),
                          ],
                        ),
                        Text("👨‍🏫 Teacher: ${entry['teacher']}"),
                        Text("🔐 Password: ${'*' * entry['password'].length}"),
                        Text("🏷️ Class ID: ${entry['classId']}"),
                        Text("⏰ Time In: ${entry['timeIn']}"),
                        Text("🏁 Out Time: ${entry['outTime'].isEmpty ? 'Not marked yet' : entry['outTime']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => scanAndShowPopup(),
        icon: Icon(Icons.qr_code_scanner),
        label: Text("Scan QR"),
      ),
    );
  }
}
