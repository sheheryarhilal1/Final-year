// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

// void main() {
//   runApp(MaterialApp(home: QRDecryptionPage()));
// }

// class QRDecryptionPage extends StatefulWidget {
//   @override
//   State<QRDecryptionPage> createState() => _QRDecryptionPageState();
// }

// class _QRDecryptionPageState extends State<QRDecryptionPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   String result = '';

//   // Replace this with your own 32-byte base64-encoded key
//   final String base64Key = 'REPLACE_WITH_YOUR_BASE64_KEY';

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;

//     controller.scannedDataStream.listen((scanData) {
//       controller.pauseCamera();
//       final scannedCode = scanData.code;

//       if (scannedCode != null && scannedCode.isNotEmpty) {
//         try {
//           final decrypted = decryptQRCodeData(scannedCode);
//           setState(() => result = "Decrypted: $decrypted");
//         } catch (e) {
//           setState(() => result = "Error: ${e.toString()}");
//         }
//       } else {
//         setState(() => result = "No valid QR data.");
//       }
//     });
//   }

//   String decryptQRCodeData(String base64Data) {
//     final key = encrypt.Key(base64.decode(base64Key));
//     final allBytes = base64.decode(base64Data);

//     final ivBytes = allBytes.sublist(0, 16);
//     final encryptedBytes = allBytes.sublist(16);

//     final iv = encrypt.IV(ivBytes);
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//     final encrypted = encrypt.Encrypted(encryptedBytes);

//     return encrypter.decrypt(encrypted, iv: iv);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("QR Decryption")),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 3,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(result, style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
