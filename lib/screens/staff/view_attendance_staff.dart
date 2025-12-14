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
                  _buildAnimatedTitle(),
                  const SizedBox(height: 12),
                  Expanded(child: _buildAnimatedStudentList()),
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
        children: [
          AnimatedRotation(
            duration: const Duration(seconds: 10),
            turns: 1,
            child: const Icon(Icons.free_breakfast,
                size: 70, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: 1,
            child: const Text(
              "It's a Free Hour",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: 1,
            child: const Text(
              "No class scheduled for this period",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- ANIMATED TITLE ----------
  Widget _buildAnimatedTitle() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: const Text(
              'Student Attendance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------- CLASS HEADER ----------
  Widget _buildClassHeader() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-50 * (1 - value), 0),
          child: Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.1 * value),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.indigo.shade100.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        curve: Curves.elasticOut,
                        builder: (context, iconValue, _) {
                          return Transform.scale(
                            scale: iconValue,
                            child: Icon(Icons.class_,
                                color: Colors.indigo.shade700),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              opacity: value,
                              child: Text(
                                className,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 600),
                              opacity: value,
                              child: Text(
                                subjectName,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// ---------- ANIMATED STUDENT LIST ----------
  Widget _buildAnimatedStudentList() {
    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final student = students[index];
        
        return _buildAnimatedStudentTile(
          roll: student["roll"]!,
          name: student["name"]!,
          status: student["status"]!,
          index: index,
        );
      },
    );
  }

  /// ---------- ANIMATED STUDENT TILE ----------
  Widget _buildAnimatedStudentTile({
    required String roll,
    required String name,
    required String status,
    required int index,
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

    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 600 + (index * 150)),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  isHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isHovered = false;
                });
              },
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // Add tap functionality here if needed
                  // e.g., show student details
                },
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: Opacity(
                      opacity: value,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isHovered ? Colors.grey.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isHovered 
                                ? statusColor.withOpacity(0.3)
                                : Colors.grey.shade300,
                            width: isHovered ? 1.5 : 1,
                          ),
                          boxShadow: [
                            if (isHovered)
                              BoxShadow(
                                color: statusColor.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              )
                            else
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05 * value),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 400 + (index * 150)),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              curve: Curves.elasticOut,
                              builder: (context, iconValue, _) {
                                return AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: isHovered ? 1.1 : 1.0,
                                  curve: Curves.easeOut,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: statusColor.withOpacity(
                                      isHovered ? 0.2 : 0.1
                                    ),
                                    child: AnimatedRotation(
                                      duration: const Duration(milliseconds: 300),
                                      turns: isHovered ? 0.02 : 0,
                                      child: Icon(statusIcon,
                                          color: statusColor, size: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 300 + (index * 150)),
                                    opacity: value,
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 200),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isHovered ? Colors.indigo.shade800 : Colors.black,
                                      ),
                                      child: Text(name),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 400 + (index * 150)),
                                    opacity: value,
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(milliseconds: 200),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isHovered ? Colors.indigo.shade600 : Colors.grey,
                                      ),
                                      child: Text(roll),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 500 + (index * 150)),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              curve: Curves.elasticOut,
                              builder: (context, statusValue, _) {
                                return AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: isHovered ? 1.15 : 1.0,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isHovered ? 10 : 0,
                                      vertical: isHovered ? 4 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isHovered ? statusColor.withOpacity(0.1) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: statusColor,
                                        fontSize: isHovered ? 13 : 14,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}