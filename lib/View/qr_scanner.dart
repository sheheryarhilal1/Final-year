import 'dart:convert';
import 'dart:developer';
import 'package:final_year/View/Setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Firestore
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

// Global attendance list (for offline caching only)
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  addData(String name, String password, String tokenno, String timein,
      String timeout) async {
    if (name == "" &&
        password == "" &&
        tokenno == "" &&
        timein == "" &&
        timeout == "") {
      log("Enter required field");
    } else {
      FirebaseFirestore.instance.collection("user").doc(name).set({
        "name": name,
        "password": password,
        "tokenno": tokenno,
        "timein": timein,
        "timeout": timeout
      }).then((value) {
        log("message");
      });
    }
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

                localAttendance.add(newEntry);
                await _saveData();

                await _firestore.collection("attendance_records").add(newEntry);
                Navigator.pop(context);
                setState(() {});
              },
            )
          else
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Mark Time Out"),
              onPressed: () async {
                localAttendance[existingIndex]["outTime"] =
                    DateTime.now().toString();
                await _saveData();
                addData(
                    teacher.toString(),
                    password.toString(),
                    data["token"] ?? "N/A",
                    DateTime.now().toString(),
                    DateTime.now().toString());

                await _firestore
                    .collection("attendance_records")
                    .where("teacher",
                        isEqualTo: localAttendance[existingIndex]["teacher"])
                    .where("classId",
                        isEqualTo: localAttendance[existingIndex]["classId"])
                    .where("token",
                        isEqualTo: localAttendance[existingIndex]["token"])
                    .get()
                    .then((snapshot) {
                  for (var doc in snapshot.docs) {
                    _firestore
                        .collection("attendance_records")
                        .doc(doc.id)
                        .update({
                      "outTime": localAttendance[existingIndex]["outTime"],
                    });
                  }
                });

                Navigator.pop(context);
                setState(() {});
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
            backgroundColor: Colors.green, // ✅ Scan screen AppBar green
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
        _buildScreenWithAppBar("History", const Center(child: Text("History Screen"))),
        HomeScreen()
      ];

  Widget _buildScreenWithAppBar(String title, Widget child) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.green, // ✅ All AppBars green
        title: Text(title),
      ),
      body: child,
    );
  }

  Widget _buildAttendanceList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("attendance_records")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No records yet. Scan a QR to add.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final entry =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
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
                            await snapshot.data!.docs[index].reference.delete();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Text("👨‍🏫 Teacher: ${entry['teacher']}",
                        style: const TextStyle(color: Colors.white)),
                    Text(
                        "🔐 Password: ${entry['password'] != null ? '*' * entry['password'].length : ''}",
                        style: const TextStyle(color: Colors.white)),
                    Text("🏷️ Class ID: ${entry['classId']}",
                        style: const TextStyle(color: Colors.white)),
                    Text("🆔 Token: ${entry['token'] ?? 'N/A'}",
                        style: const TextStyle(color: Colors.white)),
                    Text("⏰ Time In: ${entry['timeIn']}",
                        style: const TextStyle(color: Colors.white)),
                    Text(
                        "🏁 Out Time: ${entry['outTime'] != null && entry['outTime'].isNotEmpty ? entry['outTime'] : 'Not marked yet'}",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _screens()[_currentIndex],
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
