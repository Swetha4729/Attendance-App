import 'package:flutter/material.dart';

class AttendanceReports extends StatefulWidget {
  const AttendanceReports({super.key});

  @override
  State<AttendanceReports> createState() => _AttendanceReportsState();
}

class _AttendanceReportsState extends State<AttendanceReports> {
  String selectedClass = "CSE – III A";
  String selectedSubject = "Data Structures";
  String reportType = "Overall Attendance";

  DateTime? fromDate;
  DateTime? toDate;

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

  final List<String> reportTypes = [
    "Overall Attendance",
    "Student Wise",
    "Date Wise",
    "Defaulters List",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Reports',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterCard(),
            const SizedBox(height: 20),
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildDownloadButtons(),
          ],
        ),
      ),
    );
  }

  /// ---------- FILTERS ----------
  Widget _buildFilterCard() {
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
            'Report Filters',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 12),
          _buildDropdown(
            label: "Report Type",
            value: reportType,
            items: reportTypes,
            onChanged: (val) => setState(() => reportType = val),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  label: "From Date",
                  date: fromDate,
                  onTap: () => _selectDate(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDatePicker(
                  label: "To Date",
                  date: toDate,
                  onTap: () => _selectDate(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------- SUMMARY ----------
  Widget _buildSummaryCard() {
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
            'Report Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow("Total Classes", "42"),
          _buildSummaryRow("Average Attendance", "87%"),
          _buildSummaryRow("Students ≥75%", "48"),
          _buildSummaryRow("Defaulters (<75%)", "12"),
        ],
      ),
    );
  }

  /// ---------- DOWNLOAD ----------
  Widget _buildDownloadButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF report generated')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Excel report generated')),
              );
            },
            icon: const Icon(Icons.table_chart),
            label: const Text('Download Excel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  /// ---------- HELPERS ----------
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

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          date == null
              ? 'Select'
              : "${date.day}/${date.month}/${date.year}",
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }
}
