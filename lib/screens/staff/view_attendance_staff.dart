import 'package:flutter/material.dart';

class ViewAttendanceStaff extends StatelessWidget {
  const ViewAttendanceStaff({super.key});

  // Mock class info
  final String className = "CSE – III A";
  final String subjectName = "Data Structures";
  final bool isFreeHour = false; // change to true to test free hour UI

  // Mock student attendance list
  final List<Map<String, String>> students = const [
    {"roll": "21CS001", "name": "Arun Kumar", "status": "Present"},
    {"roll": "21CS002", "name": "Divya R", "status": "Absent"},
    {"roll": "21CS003", "name": "Karthik S", "status": "Present"},
    {"roll": "21CS004", "name": "Meena V", "status": "OD"},
    {"roll": "21CS005", "name": "Naveen P", "status": "Present"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Attendance',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isFreeHour
            ? _buildFreeHourUI()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassHeader(),
                  const SizedBox(height: 20),
                  const Text(
                    'Student Attendance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildStudentList()),
                ],
              ),
      ),
    );
  }

  /// ---------- FREE HOUR UI ----------
  Widget _buildFreeHourUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.free_breakfast, size: 50, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "It's a Free Hour",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "No class scheduled for this period",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ---------- CLASS HEADER ----------
  Widget _buildClassHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.class_, color: Colors.indigo.shade700),
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
        return _buildStudentTile(
          roll: student["roll"]!,
          name: student["name"]!,
          status: student["status"]!,
        );
      },
    );
  }

  /// ---------- STUDENT TILE ----------
  Widget _buildStudentTile({
    required String roll,
    required String name,
    required String status,
  }) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case "Present":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "Absent":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(statusIcon, color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  roll,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
