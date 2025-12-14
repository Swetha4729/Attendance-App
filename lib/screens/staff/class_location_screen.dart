import 'package:flutter/material.dart';

class ClassLocationScreen extends StatelessWidget {
  ClassLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Location')),
      body: const Center(
        child: Text(
          'Class location / WiFi mapping screen',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
