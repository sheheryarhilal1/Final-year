import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRScannerScreen(),
  ));
}

class QRScannerScreen extends StatefulWidget {
  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  List<Map<String, dynamic>> savedData = [];

  void showPopup(BuildContext context, String jsonData) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonData);

      TextEditingController teacherController =
          TextEditingController(text: data["teacher"] ?? "");
      TextEditingController passwordController =
          TextEditingController(text: data["password"] ?? "");
      TextEditingController classIdController =
          TextEditingController(text: data["classId"] ?? "");

      String timeIn = DateTime.now().toString();
      String? outTime;

      showDialog(
        context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Scanned QR Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: teacherController,
                    decoration: InputDecoration(labelText: "👨‍🏫 Teacher"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: "🔐 Password"),
                  ),
                  TextField(
                    controller: classIdController,
                    decoration: InputDecoration(labelText: "🏷️ Class ID"),
                  ),
                  SizedBox(height: 10),
                  Text("⏰ Time In: $timeIn"),
                  SizedBox(height: 10),
                  Text("🏁 Out Time: ${outTime ?? 'Not marked yet'}"),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text("Time In"),
                        onPressed: () {
                          setState(() {
                            timeIn = DateTime.now().toString();
                            final savedEntry = {
                              "teacher": teacherController.text,
                              "password": passwordController.text,
                              "classId": classIdController.text,
                              "timeIn": timeIn,
                              "outTime": outTime ?? "Not marked yet",
                            };
                            savedData.add(savedEntry);
                          });

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SavedDataScreen(savedData: savedData),
                            ),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.logout),
                        label: Text("Time Out"),
                        onPressed: () {
                          setState(() {
                            outTime = DateTime.now().toString();
                            final savedEntry = {
                              "teacher": teacherController.text,
                              "password": passwordController.text,
                              "classId": classIdController.text,
                              "timeIn": timeIn,
                              "outTime": outTime ?? "Not marked yet",
                            };
                            savedData.add(savedEntry);
                          });

                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SavedDataScreen(savedData: savedData),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [],
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text("Invalid QR Data"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📷 QR Scanner"),
        backgroundColor: Color(0xFFADFF2F)
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final String? data = capture.barcodes.first.rawValue;
          if (data != null) {
            showPopup(context, data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),foregroundColor: Colors.black,
        label: Text("Saved Scans"),
    backgroundColor: Color(0xFFADFF2F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SavedDataScreen(savedData: savedData),
            ),
          );
        },
      ),
    );
  }
}

class SavedDataScreen extends StatelessWidget {
  final List<Map<String, dynamic>> savedData;

  const SavedDataScreen({super.key, required this.savedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📚 Saved Scans'),
  backgroundColor: Colors.greenAccent
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: savedData.isEmpty
            ? Center(
                child: Text(
                  'No data saved yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: savedData.length,
                itemBuilder: (context, index) {
                  final entry = savedData[index];
                return InkWell(
  onTap: () {
    // // Your tap action here
    // // You can show a dialog, navigate to a new page, or print info
    // print("User tapped on: ${entry["teacher"]}");

    // // Example: show a snackbar
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Tapped on ${entry["teacher"]}")),
    // );
  },
  child: Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Teacher:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 6),
              Text(entry["teacher"]),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.lock, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Password:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 6),
              Text(entry["password"]),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.class_, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Class ID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 6),
              Text(entry["classId"]),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Time In:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 6),
              Expanded(
                child: Text(entry["timeIn"], overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Out Time:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(width: 6),
              Expanded(
                child: Text(entry["outTime"], overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
},
              ),
      ),
    );
  }
}
