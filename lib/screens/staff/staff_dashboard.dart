import 'package:flutter/material.dart';

class StaffDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Dashboard')),
      body: Center(child: Text('Staff tools: view/modify attendance, set class location')),
    );
  }
}
