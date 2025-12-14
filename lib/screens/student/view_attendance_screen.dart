import 'package:flutter/material.dart';

class ViewAttendanceScreen extends StatelessWidget {
  ViewAttendanceScreen({super.key});

  // 🔹 Semester-wise mock data
  final List<Map<String, dynamic>> semesterData = [
    {
      "semester": "Semester 1",
      "semesterNo": 1,
      "courses": [
        {"subject": "Mathematics I", "total": 40, "attended": 35},
        {"subject": "Physics", "total": 38, "attended": 30},
        {"subject": "Programming in C", "total": 45, "attended": 40},
      ],
    },
    {
      "semester": "Semester 2",
      "semesterNo": 2,
      "courses": [
        {"subject": "Mathematics II", "total": 42, "attended": 36},
        {"subject": "Data Structures", "total": 44, "attended": 38},
        {"subject": "Digital Logic", "total": 40, "attended": 28},
      ],
    },
    {
      "semester": "Semester 3",
      "semesterNo": 3,
      "courses": [
        {"subject": "DBMS", "total": 45, "attended": 40},
        {"subject": "Operating Systems", "total": 38, "attended": 32},
        {"subject": "Computer Networks", "total": 42, "attended": 30},
      ],
    },
  ];

  double _percentage(int attended, int total) {
    return (attended / total) * 100;
  }

  Color _statusColor(double percent) {
    if (percent >= 75) return Colors.green;
    if (percent >= 60) return Colors.orange;
    return Colors.red;
  }

  String _statusText(double percent) {
    if (percent >= 75) return "Good";
    if (percent >= 60) return "Warning";
    return "Low Attendance";
  }

  double _semesterOverall(List courses) {
    int total = 0;
    int attended = 0;

    for (var c in courses) {
      total += c["total"] as int;
      attended += c["attended"] as int;
    }

    return _percentage(attended, total);
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Sort semesters in DESCENDING order
    final sortedSemesterData =
        List<Map<String, dynamic>>.from(semesterData)
          ..sort((a, b) => b["semesterNo"].compareTo(a["semesterNo"]));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Details"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedSemesterData.length,
        itemBuilder: (context, index) {
          final semester = sortedSemesterData[index];
          final courses = semester["courses"] as List;
          final semesterPercent = _semesterOverall(courses);

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              childrenPadding: const EdgeInsets.all(16),
              title: Text(
                semester["semester"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: semesterPercent / 100,
                    minHeight: 8,
                    color: _statusColor(semesterPercent),
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Overall: ${semesterPercent.toStringAsFixed(1)}% • ${_statusText(semesterPercent)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _statusColor(semesterPercent),
                    ),
                  ),
                ],
              ),
              children: courses.map<Widget>((course) {
                final percent =
                    _percentage(course["attended"], course["total"]);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["subject"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        "Attended: ${course["attended"]} / ${course["total"]}"),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: percent / 100,
                      minHeight: 6,
                      color: _statusColor(percent),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${percent.toStringAsFixed(1)}% • ${_statusText(percent)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _statusColor(percent),
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
