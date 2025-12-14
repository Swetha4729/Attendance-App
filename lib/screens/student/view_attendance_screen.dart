import 'package:flutter/material.dart';

class ViewAttendanceScreen extends StatefulWidget {
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

  @override
  State<ViewAttendanceScreen> createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isAnimationInitialized = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _isAnimationInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_animationController.isDismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
        List<Map<String, dynamic>>.from(widget.semesterData)
          ..sort((a, b) => b["semesterNo"].compareTo(a["semesterNo"]));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Details"),
        centerTitle: true,
      ),
      body: _isAnimationInitialized
          ? AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sortedSemesterData.length,
                itemBuilder: (context, index) {
                  return _buildAnimatedSemesterCard(
                      sortedSemesterData[index], index);
                },
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedSemesterData.length,
              itemBuilder: (context, index) {
                return _buildSemesterCard(sortedSemesterData[index]);
              },
            ),
    );
  }

  /// ---------- ANIMATED SEMESTER CARD ----------
  Widget _buildAnimatedSemesterCard(
      Map<String, dynamic> semester, int index) {
    final courses = semester["courses"] as List;
    final semesterPercent = _semesterOverall(courses);

    // Calculate delay with bounds checking
    double baseDelay = 0.2;
    double delay = baseDelay + (index * 0.15);
    delay = delay.clamp(0.0, 1.0);
    double endDelay = (delay + 0.2).clamp(0.0, 1.0);

    // Ensure start < end
    if (delay >= endDelay) {
      endDelay = delay + 0.1;
      if (endDelay > 1.0) {
        endDelay = 1.0;
        delay = 0.9;
      }
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, endDelay, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, endDelay, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(delay, endDelay, curve: Curves.elasticOut),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isExpanded = false;
              bool isHovered = false;

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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      if (isHovered)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                          spreadRadius: 2,
                        )
                      else
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      childrenPadding: const EdgeInsets.all(16),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          isExpanded = expanded;
                        });
                      },
                      title: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isHovered
                              ? Colors.blue.shade800
                              : Colors.black,
                        ),
                        child: Text(semester["semester"]),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-1.0, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                    delay + 0.1, endDelay, curve: Curves.easeOut),
                              ),
                            ),
                            child: LinearProgressIndicator(
                              value: semesterPercent / 100,
                              minHeight: 8,
                              color: _statusColor(semesterPercent),
                              backgroundColor: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                  delay + 0.15, endDelay, curve: Curves.easeIn),
                            ),
                            child: Text(
                              "Overall: ${semesterPercent.toStringAsFixed(1)}% • ${_statusText(semesterPercent)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _statusColor(semesterPercent),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: isExpanded ? 0.5 : 0,
                        child: Icon(
                          Icons.expand_more,
                          color: isHovered
                              ? Colors.blue.shade800
                              : Colors.grey.shade700,
                        ),
                      ),
                      children: _buildAnimatedCourseList(courses, delay),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED COURSE LIST ----------
  List<Widget> _buildAnimatedCourseList(List courses, double baseDelay) {
    return courses.asMap().entries.map((entry) {
      final index = entry.key;
      final course = entry.value;
      final percent = _percentage(course["attended"], course["total"]);

      // Calculate delay for each course item
      double delay = baseDelay + 0.3 + (index * 0.1);
      delay = delay.clamp(0.0, 1.0);
      double endDelay = (delay + 0.2).clamp(0.0, 1.0);

      // Ensure start < end
      if (delay >= endDelay) {
        endDelay = delay + 0.1;
        if (endDelay > 1.0) {
          endDelay = 1.0;
          delay = 0.9;
        }
      }

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, endDelay, curve: Curves.easeOut),
          ),
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: Interval(delay, endDelay, curve: Curves.easeIn),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isHovered = false;

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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? Colors.grey.shade50
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(delay, delay + 0.2,
                                curve: Curves.elasticOut),
                          ),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isHovered
                                ? Colors.blue.shade800
                                : Colors.black,
                          ),
                          child: Text(course["subject"]),
                        ),
                      ),
                      const SizedBox(height: 4),
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(delay + 0.1, delay + 0.3,
                              curve: Curves.easeIn),
                        ),
                        child: Text(
                          "Attended: ${course["attended"]} / ${course["total"]}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1.0, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(delay + 0.15, delay + 0.35,
                                curve: Curves.easeOut),
                          ),
                        ),
                        child: LinearProgressIndicator(
                          value: percent / 100,
                          minHeight: 6,
                          color: _statusColor(percent),
                          backgroundColor: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(delay + 0.2, delay + 0.4,
                                  curve: Curves.elasticOut),
                            ),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isHovered
                                  ? _statusColor(percent).withOpacity(0.9)
                                  : _statusColor(percent),
                              fontSize: isHovered ? 15 : 14,
                            ),
                            child: Text(
                              "${percent.toStringAsFixed(1)}% • ${_statusText(percent)}",
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 24,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }

  /// ---------- STATIC SEMESTER CARD ----------
  Widget _buildSemesterCard(Map<String, dynamic> semester) {
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
          final percent = _percentage(course["attended"], course["total"]);

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
              Text("Attended: ${course["attended"]} / ${course["total"]}"),
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
  }
}