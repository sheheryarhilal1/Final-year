import 'package:final_year/Controller/attendence_controllere.dart';
import 'package:get/get.dart';
// import '../controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceController());
  }
}
