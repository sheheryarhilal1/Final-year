import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import 'qr_scanner.dart';

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final Uuid uuid = Uuid();
  Map<String, String> qrData = {
    "ssid": "MyWiFi",
    "password": "12345678",
    "teacher": "Mr. Ali",
    "classId": "Class10A",
    "yume": "2025Batch",
    "token": ""
  };

  String jsonData = "";

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateQR(); // initial QR
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _generateQR(); // update QR every 30 seconds
    });
  }

  void _generateQR() {
    setState(() {
      qrData["token"] = uuid.v4(); // generate unique token
      jsonData = jsonEncode(qrData);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // stop timer when screen closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              foregroundColor: Colors.greenAccent,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRManagerScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Go to Scanner',
                style: TextStyle(
                  color: Colors.black,
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
