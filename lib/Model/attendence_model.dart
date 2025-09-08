// class AttendanceModel {
//   final String teacherId;
//   final String classNo;
//   final String inTime;
//   final String outTime;

//   AttendanceModel({
//     required this.teacherId,
//     required this.classNo,
//     required this.inTime,
//     required this.outTime,
//   });
// }
class AttendanceRecord {
  String teacherName;
  String classId;
  String password;
  String timeIn;
  String? timeOut;

  AttendanceRecord({
    required this.teacherName,
    required this.classId,
    required this.password,
    required this.timeIn,
    this.timeOut,
  });

  factory AttendanceRecord.fromQR(Map<String, dynamic> data) {
  return AttendanceRecord(
    teacherName: data["teacherName"] ?? "Unknown",
    classId: data["classId"] ?? "",
    password: data["password"] ?? "",
    timeIn: "", // ✅ always empty when new scan
  );
}

}
