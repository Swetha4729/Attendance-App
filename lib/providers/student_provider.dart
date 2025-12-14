import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class StudentProvider extends ChangeNotifier {
  List<AttendanceModel> attendanceList = [];

  void loadAttendance() {
    attendanceList = [
      AttendanceModel(date: '2025-01-01', present: true),
      AttendanceModel(date: '2025-01-02', present: false),
    ];
    notifyListeners();
  }
}
