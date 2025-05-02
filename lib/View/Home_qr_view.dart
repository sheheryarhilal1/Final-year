import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'qr_popup.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final QRViewController? qrController = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR")),
      body: QRView(
        key: qrKey,
        onQRViewCreated: (controller) {
          controller.scannedDataStream.listen((scanData) {
            controller.pauseCamera();
            // Get.dialog(QRPopup(teacherId: scanData.code ?? 'Unknown'));
          });
        },
      ),
    );
  }
}
