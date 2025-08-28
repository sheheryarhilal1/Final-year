// import 'package:final_year/Model/attendence_model.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// // import '../models/attendance_model.dart';

// class AttendanceController extends GetxController {
//   var teacherId = ''.obs;
//   var classNo = ''.obs;
//   late String inTime;
//   late String outTime;

//   @override
//   void onInit() {
//     final now = DateTime.now();
//     final formatter = DateFormat('hh:mm:ss a');
//     inTime = formatter.format(now);
//     outTime = formatter.format(now.add(Duration(hours: 1)));
//     super.onInit();
//   }

//   void submitAttendance() {
//     final attendance = AttendanceModel(
//       teacherId: teacherId.value,
//       classNo: classNo.value,
//       inTime: inTime,
//       outTime: outTime,
//     );

//     // Replace this with actual DB or Firebase storage logic
//     print("Attendance submitted: ${attendance.teacherId}, ${attendance.classNo}");
//     Get.snackbar("Success", "Attendance Submitted");
//   }
// }
