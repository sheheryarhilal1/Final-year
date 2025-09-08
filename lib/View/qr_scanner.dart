import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRManagerScreen(),
  ));
}

// Global local list
List<Map<String, dynamic>> localAttendance = [];

class QRManagerScreen extends StatefulWidget {
  @override
  State<QRManagerScreen> createState() => _QRManagerScreenState();
}

class _QRManagerScreenState extends State<QRManagerScreen> {
  // Function to show popup after scanning QR
  Future<void> showPopup(
    BuildContext context,
    Map<String, dynamic> data, {
    int? existingIndex,
  }) async {
    String teacher = data["teacher"] ?? "";
    String password = data["password"] ?? "";
    String classId = data["classId"] ?? "";

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
            Text("👨‍🏫 Teacher: $teacher"),
            Text("🔐 Password: $password"),
            Text("🏷️ Class ID: $classId"),
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
              onPressed: () {
                final newEntry = {
                  "teacher": teacher,
                  "password": password,
                  "classId": classId,
                  "timeIn": DateTime.now().toString(),
                  "outTime": "",
                };
                localAttendance.add(newEntry);
                Navigator.pop(context);
                setState(() {});
              },
            )
          else
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text("Mark Time Out"),
              onPressed: () {
                localAttendance[existingIndex]["outTime"] =
                    DateTime.now().toString();
                Navigator.pop(context);
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  // Scanner widget
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
                  Navigator.pop(context); // Close scanner
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
                          ],
                        ),
                        Text("👨‍🏫 Teacher: ${entry['teacher']}"),
                        Text("🔐 Password: ${entry['password']}"),
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
