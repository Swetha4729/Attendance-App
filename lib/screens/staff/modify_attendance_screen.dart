import 'package:flutter/material.dart';

class ModifyAttendanceScreen extends StatefulWidget {
  const ModifyAttendanceScreen({super.key});

  @override
  State<ModifyAttendanceScreen> createState() =>
      _ModifyAttendanceScreenState();
}

class _ModifyAttendanceScreenState extends State<ModifyAttendanceScreen> {
  final String className = "CSE – III A";
  final String subjectName = "Data Structures";

  List<Map<String, String>> students = [
    {"roll": "21CS001", "name": "Arun Kumar", "status": "Present"},
    {"roll": "21CS002", "name": "Divya R", "status": "Absent"},
    {"roll": "21CS003", "name": "Karthik S", "status": "OD"},
    {"roll": "21CS004", "name": "Meena V", "status": "Present"},
    {"roll": "21CS005", "name": "Naveen P", "status": "Absent"},
  ];

  final List<String> statusOptions = ["Present", "Absent", "OD"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modify Attendance',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassHeader(),
            const SizedBox(height: 20),
            const Text(
              'Tap the status button to modify attendance',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildStudentList()),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  /// ---------- CLASS HEADER ----------
  Widget _buildClassHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.class_, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                className,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subjectName,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------- STUDENT LIST ----------
  Widget _buildStudentList() {
    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final student = students[index];
        return _buildStudentTile(index, student);
      },
    );
  }

  /// ---------- STUDENT TILE ----------
  Widget _buildStudentTile(int index, Map<String, String> student) {
    Color statusColor = _getStatusColor(student["status"]!);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: statusColor.withOpacity(0.15),
            child: Text(
              student["name"]![0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student["name"]!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  student["roll"]!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          /// --------- COLORED STATUS DROPDOWN ----------
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: student["status"],
              icon: Icon(Icons.arrow_drop_down, color: statusColor),
              dropdownColor: Colors.white,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              items: statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  students[index]["status"] = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- SAVE BUTTON ----------
  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Attendance updated successfully'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  /// ---------- STATUS COLOR ----------
  Color _getStatusColor(String status) {
    switch (status) {
      case "Present":
        return Colors.green;
      case "Absent":
        return Colors.red;
      case "OD":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
