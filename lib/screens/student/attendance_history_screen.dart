import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: const Center(
        child: Text(
          'Attendance history will be shown here',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
