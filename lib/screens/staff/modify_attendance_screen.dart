import 'package:flutter/material.dart';

class ModifyAttendanceScreen extends StatelessWidget {
  ModifyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modify Attendance')),
      body: const Center(
        child: Text(
          'Modify attendance screen',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
