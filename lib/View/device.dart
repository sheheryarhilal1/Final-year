import 'dart:developer';

import 'package:final_year/Model/User_device_model.dart';
import 'package:final_year/View/QR_CODE.dart';
import 'package:final_year/View/qr_vie.dart';
import 'package:final_year/service/shared_preference.dart';
import 'package:final_year/utils/custom_widget/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<DeviceModel> allDeviceData = [];

  void getTaskListner() {
    SharedPreferencesService().listenToUserDevices().listen((allTask) {
      debugPrint('Received Data: $allTask');
      setState(() {
        allDeviceData = allTask;
      });
    }, onError: (error) {
      debugPrint('Error in Listener: $error');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskListner();
  }

  void _showEditNameDialog(BuildContext context, DeviceModel device) {
    final TextEditingController _nameController =
        TextEditingController(text: device.deviceName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFADFF2F),
          title: Text('Edit Device Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await SharedPreferencesService().updateDeviceName(
                    deviceId: device.deviceId ?? "",
                    newName: _nameController.text,
                  );
                  Navigator.of(context).pop();
                  getTaskListner();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFADFF2F),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () async {
                  log(allDeviceData.toString());
                  getTaskListner();
                },
                child: Text("device_list".tr)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QRDecryptionPage()));
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                ))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: allDeviceData.length,
          itemBuilder: (context, index) {
            final device = allDeviceData[index];

            return DeviceCard(
                title: '${allDeviceData[index].deviceName}',
                macAddress: '${allDeviceData[index].deviceMac}',
                deviceId: '${allDeviceData[index].deviceId}',
                ipAddress: '${allDeviceData[index].deviceIp}',
                onSetting: () {
                  _showEditNameDialog(context, device);
                },
                onDelete: () {
                  SharedPreferencesService().deleteDeviceData(
                      deviceId: allDeviceData[index].deviceId ?? "");
                });
          },
        ),
      ),
    );
  }
}
