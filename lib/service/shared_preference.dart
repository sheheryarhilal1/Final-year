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
