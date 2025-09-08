// import 'package:flutter/material.dart';
// import '../Model/attendence_model.dart';

// class SavedDataScreen extends StatefulWidget {
//   final List<AttendanceRecord> records;

//   const SavedDataScreen({Key? key, required this.records, required Null Function(dynamic record) onEdit}) : super(key: key);

//   @override
//   _SavedDataScreenState createState() => _SavedDataScreenState();
// }

// class _SavedDataScreenState extends State<SavedDataScreen> {
//   late List<AttendanceRecord> _records;

//   @override
//   void initState() {
//     super.initState();
//     _records = List.from(widget.records); // copy list
//   }

//   void _updateRecord(int index, AttendanceRecord updatedRecord) {
//     setState(() {
//       _records[index] = updatedRecord;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Saved Attendance")),
//       body: ListView.builder(
//         itemCount: _records.length,
//         itemBuilder: (context, index) {
//           final r = _records[index];
//           return Card(
//             child: ListTile(
//               title: Text("👨 Teacher: ${r.teacherName}"),
//               subtitle: Text(
//                 "🔑 Password: ${r.password}\n"
//                 "📘 Class: ${r.classId}\n"
//                 "⏰ Time In: ${r.timeIn}\n"
//                 "⏳ Time Out: ${r.timeOut ?? "Not marked"}",
//               ),
//               trailing: IconButton(
//                 icon: Icon(Icons.edit, color: Colors.deepPurple),
//                 onPressed: () async {
//                   // ✅ Go to scanner with current record
//                   final updated = await Navigator.pushNamed(
//                     context,
//                     "/scanner",
//                     arguments: r,
//                   );

//                   if (updated != null && updated is AttendanceRecord) {
//   _updateRecord(index, updated);
// }

//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
