// import 'dart:convert';

// import 'package:final_year/Model/User_device_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesService {
//   final String _devicesKey = 'user_devices';

//   Stream<List<DeviceModel>> listenToUserDevices() async* {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     while (true) {
//       final devicesData = prefs.getStringList(_devicesKey) ?? [];
//       final devices = devicesData
//           .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
//           .toList();
//       yield devices;
//       await Future.delayed(const Duration(seconds: 1)); // Simulated polling
//     }
//   }

//   /// Save a device (add or update)
//   Future<void> sendDeviceData({required DeviceModel data}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final devicesData = prefs.getStringList(_devicesKey) ?? [];

//     // Parse existing devices
//     final devices = devicesData
//         .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
//         .toList();

//     // Update or add device
//     // final index = devices.indexWhere((d) => d.deviceId == data.deviceId);
//     // if (index != -1) {
//     //   devices[index] = data.copyWith(
//     //       // lastUpdated: Timestamp.now().toDate()); // Update existing device
//     // } else {
//     //   devices.add(data.copyWith(
//     //       lastUpdated: Timestamp.now().toDate())); // Add new device
//     // }

//     // Save back to SharedPreferences
//     final updatedDevicesData =
//         devices.map((device) => jsonEncode(device.toJson())).toList();
//     await prefs.setStringList(_devicesKey, updatedDevicesData);
//   }

//   /// Update specific fields of a device
//   Future<void> updateDeviceData({
//     required String deviceId,
//     String? updatedIp,
//     String? updatedMac,
//     String? updatedName,
//   }) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final devicesData = prefs.getStringList(_devicesKey) ?? [];

//     // Parse existing devices
//     final devices = devicesData
//         .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
//         .toList();

//     // Update the specified device
//     final index = devices.indexWhere((d) => d.deviceId == deviceId);
//     if (index != -1) {
//       final updatedDevice = devices[index].copyWith(
//         deviceIp: updatedIp,
//         deviceMac: updatedMac,
//         deviceName: updatedName,
//         // lastUpdated: Timestamp.now().toDate(),
//       );
//       devices[index] = updatedDevice;

//       // Save updated list back to SharedPreferences
//       final updatedDevicesData =
//           devices.map((device) => jsonEncode(device.toJson())).toList();
//       await prefs.setStringList(_devicesKey, updatedDevicesData);
//     }
//   }

//   /// Delete a device
//   Future<void> deleteDeviceData({required String deviceId}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final devicesData = prefs.getStringList(_devicesKey) ?? [];

//     // Parse and filter out the device
//     final updatedDevicesData = devicesData
//         .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
//         .where((device) => device.deviceId != deviceId)
//         .map((device) => jsonEncode(device.toJson()))
//         .toList();

//     // Save updated list back to SharedPreferences
//     await prefs.setStringList(_devicesKey, updatedDevicesData);
//   }

//   Future<void> updateDeviceName(
//       {required String deviceId, required String newName}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final devicesData = prefs.getStringList(_devicesKey) ?? [];

//     final devices = devicesData
//         .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
//         .toList();

//     final int index =
//         devices.indexWhere((device) => device.deviceId == deviceId);
//     if (index != -1) {
//       devices[index] = devices[index].copyWith(
//         deviceName: newName,
//         // lastUpdated: Timestamp.now().toDate(),
//       );

//       final updatedDevicesData =
//           devices.map((device) => jsonEncode(device.toJson())).toList();
//       await prefs.setStringList(_devicesKey, updatedDevicesData);
//     }
//   }

//   // Helper method to get user devices
//   Future<List<DeviceModel>> getUserDevices() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final devicesData = prefs.getStringList(_devicesKey) ?? [];
//     return devicesData
//         .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
//         .toList();
//   }
// }
import 'dart:convert';
import 'package:final_year/Model/User_device_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final String _devicesKey = 'user_devices';

  Stream<List<DeviceModel>> listenToUserDevices() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    while (true) {
      final devicesData = prefs.getStringList(_devicesKey) ?? [];
      final devices = devicesData
          .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
          .toList();
      yield devices;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  /// Save a device (add or update)
  Future<void> sendDeviceData({required DeviceModel data}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    final devices = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .toList();

    final index = devices.indexWhere((d) => d.deviceId == data.deviceId);
    if (index != -1) {
      devices[index] = data;
    } else {
      devices.add(data);
    }

    final updatedDevicesData =
        devices.map((device) => jsonEncode(device.toJson())).toList();
    await prefs.setStringList(_devicesKey, updatedDevicesData);
  }

  Future<void> updateDeviceData({
    required String deviceId,
    String? updatedIp,
    String? updatedMac,
    String? updatedName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    final devices = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .toList();

    final index = devices.indexWhere((d) => d.deviceId == deviceId);
    if (index != -1) {
      final updatedDevice = devices[index].copyWith(
        deviceIp: updatedIp,
        deviceMac: updatedMac,
        deviceName: updatedName,
      );
      devices[index] = updatedDevice;

      final updatedDevicesData =
          devices.map((device) => jsonEncode(device.toJson())).toList();
      await prefs.setStringList(_devicesKey, updatedDevicesData);
    }
  }

  Future<void> deleteDeviceData({required String deviceId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    final updatedDevicesData = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .where((device) => device.deviceId != deviceId)
        .map((device) => jsonEncode(device.toJson()))
        .toList();

    await prefs.setStringList(_devicesKey, updatedDevicesData);
  }

  Future<void> updateDeviceName({
    required String deviceId,
    required String newName,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final devicesData = prefs.getStringList(_devicesKey) ?? [];

    final devices = devicesData
        .map((deviceJson) => DeviceModel.fromJson(jsonDecode(deviceJson)))
        .toList();

    final index = devices.indexWhere((device) => device.deviceId == deviceId);
    if (index != -1) {
      devices[index] = devices[index].copyWith(deviceName: newName);

      final updatedDevicesData =
          devices.map((device) => jsonEncode(device.toJson())).toList();
      await prefs.setStringList(_devicesKey, updatedDevicesData);
    }
  }
}
