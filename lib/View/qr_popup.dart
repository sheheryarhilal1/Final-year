import 'package:final_year/Controller/attendence_controllere.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/attendance_controller.dart';

class AttendanceFormView extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Teacher Attendance'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) => controller.teacherId.value = value,
            decoration: InputDecoration(
              labelText: 'Teacher ID',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) => controller.classNo.value = value,
            decoration: InputDecoration(
              labelText: 'Class No',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'In Time',
              border: OutlineInputBorder(),
              hintText: controller.inTime,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Out Time',
              border: OutlineInputBorder(),
              hintText: controller.outTime,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: controller.submitAttendance,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
