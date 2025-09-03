import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRScannerScreen(),
  ));
}

// Global local list
List<Map<String, dynamic>> localAttendance = [];

// ---------- Standalone Popup Function ----------
Future<void> showPopup(
  BuildContext context,
  Map<String, dynamic> data, {
  int? existingIndex,
}) async {
  TextEditingController teacherController =
      TextEditingController(text: data["teacher"] ?? "");
  TextEditingController passwordController =
      TextEditingController(text: data["password"] ?? "");
  TextEditingController classIdController =
      TextEditingController(text: data["classId"] ?? "");

  String timeIn = data["timeIn"] ?? "";
  String? outTime =
      (data["outTime"] != "Not marked yet" && data["outTime"] != null)
          ? data["outTime"]
          : null;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text('QR Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: teacherController,
                decoration: InputDecoration(labelText: "👨‍🏫 Teacher"),
                enabled: existingIndex == null,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "🔐 Password"),
                enabled: existingIndex == null,
              ),
              TextField(
                controller: classIdController,
                decoration: InputDecoration(labelText: "🏷️ Class ID"),
                enabled: existingIndex == null,
              ),
              SizedBox(height: 10),
              Text("⏰ Time In: ${timeIn.isNotEmpty ? timeIn : 'Not marked yet'}"),
              SizedBox(height: 10),
              Text("🏁 Out Time: ${outTime ?? 'Not marked yet'}"),
              SizedBox(height: 12),

              if (existingIndex == null)
                ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text("Mark Time In"),
                  onPressed: () async {
                    final newTimeIn = DateTime.now().toString();
                    final savedEntry = {
                      "teacher": teacherController.text,
                      "password": passwordController.text,
                      "classId": classIdController.text,
                      "timeIn": newTimeIn,
                      "outTime": "Not marked yet",
                    };

                    // Save in local list
                    localAttendance.add(savedEntry);

                    Navigator.of(context, rootNavigator: true).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Time In saved!")),
                    );

                    Future.microtask(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SavedDataScreen()),
                      );
                    });
                  },
                )
              else
                ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text("Mark Time Out"),
                  onPressed: () async {
                    final newOutTime = DateTime.now().toString();

                    localAttendance[existingIndex]["outTime"] = newOutTime;

                    Navigator.of(context, rootNavigator: true).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Time Out saved!")),
                    );

                    Future.microtask(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SavedDataScreen()),
                      );
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ---------- Scanner Screen ----------
class QRScannerScreen extends StatefulWidget {
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📷 QR Scanner"),
        backgroundColor: Color(0xFFADFF2F),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final String? data = capture.barcodes.first.rawValue;
          if (data != null) {
            try {
              final decoded = jsonDecode(data);
              showPopup(context, decoded);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Invalid QR Data")),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        foregroundColor: Colors.black,
        label: Text("Saved Scans"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SavedDataScreen()),
          );
        },
      ),
    );
  }
}

// ---------- Saved Data Screen ----------
class SavedDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (localAttendance.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('📚 Saved Scans'),
          backgroundColor: Colors.greenAccent,
        ),
        body: Center(
          child: Text(
            'No data saved yet.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('📚 Saved Scans'),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          showPopup(context, entry, existingIndex: index);
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.delete, color: Colors.red),
                      //   onPressed: () async {
                      //     localAttendance.removeAt(index);
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text("Record deleted!")),
                      //     );
                      //     (context as Element).reassemble();
                      //   },
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text('Teacher:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 6),
                      Text(entry["teacher"] ?? ""),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.lock, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text('Password:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 6),
                      Text(entry["password"] ?? ""),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.class_, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text('Class ID:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 6),
                      Text(entry["classId"] ?? ""),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text('Time In:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 6),
                      Expanded(
                          child: Text(entry["timeIn"] ?? "",
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text('Out Time:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 6),
                      Expanded(
                          child: Text(entry["outTime"] ?? "",
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
