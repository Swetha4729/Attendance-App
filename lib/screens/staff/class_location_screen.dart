import 'package:flutter/material.dart';

class ClassLocationScreen extends StatefulWidget {
  const ClassLocationScreen({super.key});

  @override
  State<ClassLocationScreen> createState() => _ClassLocationScreenState();
}

class _ClassLocationScreenState extends State<ClassLocationScreen> {
  String selectedClass = "CSE – III A";
  String selectedSubject = "Data Structures";

  String roomNumber = "A403";
  String wifiSSID = "MCET-A403";

  final List<String> classes = [
    "CSE – I A",
    "CSE – II A",
    "CSE – III A",
    "CSE – IV A",
  ];

  final List<String> subjects = [
    "Data Structures",
    "Operating Systems",
    "DBMS",
    "Computer Networks",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Class Location Setup',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassAndSubjectCard(),
            const SizedBox(height: 20),
            _buildRoomAndWifiCard(),
            const SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// ---------- CLASS & SUBJECT ----------
  Widget _buildClassAndSubjectCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Class Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: "Class",
            value: selectedClass,
            items: classes,
            onChanged: (val) => setState(() => selectedClass = val),
          ),
          const SizedBox(height: 12),
          _buildDropdown(
            label: "Subject",
            value: selectedSubject,
            items: subjects,
            onChanged: (val) => setState(() => selectedSubject = val),
          ),
        ],
      ),
    );
  }

  /// ---------- ROOM & WIFI ----------
  Widget _buildRoomAndWifiCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Class Location (Wi-Fi Based)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: roomNumber,
            decoration: const InputDecoration(
              labelText: 'Room Number (eg: A403, C127)',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => roomNumber = val,
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: wifiSSID,
            decoration: const InputDecoration(
              labelText: 'Allowed Wi-Fi Router Name (SSID)',
              border: OutlineInputBorder(),
              helperText:
                  'Only students connected to this Wi-Fi can mark attendance',
            ),
            onChanged: (val) => wifiSSID = val,
          ),
        ],
      ),
    );
  }

  /// ---------- SAVE ----------
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location set for $selectedClass ($roomNumber)',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Save Class Location',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// ---------- DROPDOWN ----------
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (val) => onChanged(val!),
    );
  }
}
