import 'package:final_year/View/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class QRGeneratorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> qrData = {
      "ssid": "MyWiFi",
      "password": "12345678",
      "teacher": "Mr. Ali",
      "classId": "Class10A",
      "yume": "2025Batch"
    };

    String jsonData = jsonEncode(qrData);

    return Scaffold(
appBar: AppBar(
  title: Text("QR Generator"),
  backgroundColor: Color(0xFFADFF2F),
),
backgroundColor: Colors.black87.withOpacity(0.9),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
  data: jsonData,
  size: 250,
  version: QrVersions.auto,
  foregroundColor: Colors.greenAccent // your green-yellow shade
),

            SizedBox(height: 20),
           ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.lightGreenAccent,      // button background color
    foregroundColor: Colors.white,      // text color
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // rounded corners
    ),
  ),
  child: Text(
    'Go to Scanner',
    style: TextStyle(
      color: Colors.black,        // text foreground color
      backgroundColor: Colors.greenAccent, // text background if needed
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
)

          ],
        ),
      ),
    );
  }
}
