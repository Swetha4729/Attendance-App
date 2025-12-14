// lib/screens/student/mark_attendance_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/biometric_service.dart';
import '../../services/wifi_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MarkAttendanceScreen extends StatefulWidget {
  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final BiometricService _bio = BiometricService();
  final WifiService _wifi = WifiService();
  String? _ssid;
  bool _loading = false;
  String status = '';

  @override
  void initState() {
    super.initState();
    _fetchSsid();
  }

  Future<void> _fetchSsid() async {
    final s = await _wifi.getWifiName();
    setState(() => _ssid = s);
  }

  Future<void> _markWithFingerprint() async {
    setState(() { _loading = true; status = 'Authenticating...'; });
    final ok = await _bio.authenticate();
    if (!ok) {
      setState(() { _loading = false; status = 'Biometric authentication failed'; });
      return;
    }

    final token = await AuthService.getToken();
    if (token == null) {
      setState(() { _loading = false; status = 'Token missing'; });
      return;
    }

    try {
      final res = await ApiService.post('/api/attendance/mark', body: {
        'studentId': 'studentIdPlaceholder',
        'method': 'fingerprint',
        'router': _ssid ?? 'unknown'
      }, headers: { 'Authorization': 'Bearer $token' });

      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() { status = 'Attendance marked successfully'; });
      } else {
        setState(() { status = 'Server rejected: ${res.statusCode} ${res.body}'; });
      }
    } catch (e) {
      setState(() { status = 'Error: $e'; });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markWithFace() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (photo == null) return;
    setState(() { _loading = true; status = 'Uploading image...'; });

    final token = await AuthService.getToken();
    if (token == null) {
      setState(() { _loading = false; status = 'Token missing'; });
      return;
    }

    final file = File(photo.path);
    try {
      final streamed = await ApiService.upload('/api/attendance/mark', fields: {
        'studentId': 'studentIdPlaceholder',
        'method': 'face',
        'router': _ssid ?? 'unknown'
      }, file: file, token: token);

      final res = await http.Response.fromStream(streamed);
      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() { status = 'Face attendance success'; });
      } else {
        setState(() { status = 'Server error: ${res.statusCode} ${res.body}'; });
      }
    } catch (e) {
      setState(() { status = 'Upload failed: $e'; });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Detected Wi-Fi: ${_ssid ?? "unknown"}'),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.fingerprint),
              label: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Mark with Fingerprint'),
              onPressed: _loading ? null : _markWithFingerprint,
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Mark with Face'),
              onPressed: _loading ? null : _markWithFace,
            ),
            SizedBox(height: 20),
            Text(status),
          ],
        ),
      ),
    );
  }
}
