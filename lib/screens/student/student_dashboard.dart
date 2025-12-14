import 'package:flutter/material.dart';
import 'mark_attendance_screen.dart';
import 'view_attendance_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class StudentDashboard extends StatelessWidget {
  // Sample data for the graph
  final List<FlSpot> attendanceData = [
    FlSpot(1, 80),
    FlSpot(2, 85),
    FlSpot(3, 90),
    FlSpot(4, 75),
    FlSpot(5, 95),
    FlSpot(6, 88),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Attendance Analytics Graph
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Attendance Analytics',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, interval: 20),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text('M${value.toInt()}');
                                },
                                interval: 1,
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: attendanceData,
                              isCurved: true,
                              barWidth: 3,
                              color: Colors.blue,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // View Attendance Button
            ElevatedButton.icon(
              icon: Icon(Icons.visibility),
              label: const Text('View Attendance'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewAttendanceScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
