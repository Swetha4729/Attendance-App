import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'mark_attendance_screen.dart';
import 'view_attendance_screen.dart';
import '../auth/login_screen.dart';

class StudentDashboard extends StatefulWidget {
  StudentDashboard({super.key});

  // Weekly attendance data
  final List<double> attendanceValues = [80, 85, 90, 75, 95, 88];
  final List<String> weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        elevation: 0,
        actions: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.blue.shade800),
              onPressed: () {
                // Navigate to Login Screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _isAnimationInitialized
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimatedHeader(),
                        const SizedBox(height: 20),
                        _buildAnimatedStatsCards(),
                        const SizedBox(height: 24),
                        _buildAnimatedChartCard(),
                        const SizedBox(height: 24),
                        _buildAnimatedQuickActions(),
                        const SizedBox(height: 24),
                        _buildAnimatedRecentActivity(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildStatsCards(),
                      const SizedBox(height: 24),
                      _buildChartCard(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildRecentActivity(),
                      const SizedBox(height: 30),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED HEADER ----------
  Widget _buildAnimatedHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.1, 0.5, curve: Curves.easeIn),
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
                ),
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade800],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.5, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
                      ),
                      child: Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
                      ),
                      child: const Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined,
                              size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            'Computer Science',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- ANIMATED STATS CARDS ----------
  Widget _buildAnimatedStatsCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildAnimatedStatCard(
            title: "Total Classes",
            value: "60",
            icon: Icons.school_outlined,
            color: Colors.blue,
            index: 0,
          ),
          const SizedBox(width: 10),
          _buildAnimatedStatCard(
            title: "Attended",
            value: "52",
            icon: Icons.check_circle_outline,
            color: Colors.green,
            index: 1,
          ),
          const SizedBox(width: 10),
          _buildAnimatedStatCard(
            title: "Percentage",
            value: "87%",
            icon: Icons.trending_up_outlined,
            color: Colors.orange,
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    // Calculate delay with bounds checking
    double baseDelay = 0.3;
    double delay = baseDelay + (index * 0.1);
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
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? color.withOpacity(0.15)
                        : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isHovered
                            ? color.withOpacity(0.3)
                            : color.withOpacity(0.2)),
                    boxShadow: [
                      if (isHovered)
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isHovered ? 1.1 : 1.0,
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: isHovered ? 19 : 18,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                        child: Text(value),
                      ),
                      const SizedBox(height: 4),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: 11,
                          color: isHovered
                              ? Colors.grey.shade900
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED CHART CARD ----------
  Widget _buildAnimatedChartCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
            ),
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weekly Attendance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: const Interval(0.6, 0.9, curve: Curves.elasticOut),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '6 Days',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
                    ),
                    child: Text(
                      'Last week\'s performance',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Animated Bar Chart
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    height: 150,
                    child: BarChart(
                      BarChartData(
                        maxY: 100,
                        minY: 0,
                        alignment: BarChartAlignment.spaceAround,
                        groupsSpace: 12,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 25,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < widget.weekLabels.length) {
                                  return Text(
                                    widget.weekLabels[index],
                                    style: const TextStyle(fontSize: 11),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        barGroups: widget.attendanceValues.asMap().entries.map((entry) {
                          final index = entry.key;
                          final value = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: value,
                                width: 12,
                                color: value >= 75
                                    ? Colors.green
                                    : value >= 60
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Legend
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedLegend(Colors.green, 'Good (≥75%)', 0.75),
                        const SizedBox(width: 12),
                        _buildAnimatedLegend(Colors.orange, 'Average (60-74%)', 0.8),
                        const SizedBox(width: 12),
                        _buildAnimatedLegend(Colors.red, 'Low (<60%)', 0.85),
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
  }

  Widget _buildAnimatedLegend(Color color, String text, double delay) {
    // Clamp delay to ensure it's within bounds
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

    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, endDelay, curve: Curves.elasticOut),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// ---------- ANIMATED QUICK ACTIONS ----------
  Widget _buildAnimatedQuickActions() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.6, 0.9, curve: Curves.elasticOut),
                ),
              ),
              child: const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Mark Attendance Button
            _buildAnimatedActionButton(
              label: 'Mark Attendance',
              icon: Icons.fingerprint,
              isPrimary: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MarkAttendanceScreen()),
                );
              },
              index: 0,
            ),

            const SizedBox(height: 10),

            // View Attendance Button
            _buildAnimatedActionButton(
              label: 'View Attendance',
              icon: Icons.calendar_view_week_outlined,
              isPrimary: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ViewAttendanceScreen()),
                );
              },
              index: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedActionButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
    required int index,
  }) {
    // Calculate delay with bounds checking
    double baseDelay = 0.7;
    double delay = baseDelay + (index * 0.1);
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
            bool isPressed = false;

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
                onTapDown: (_) {
                  setState(() {
                    isPressed = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    isPressed = false;
                  });
                  onPressed();
                },
                onTapCancel: () {
                  setState(() {
                    isPressed = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 50,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? (isPressed
                            ? Colors.blue.shade800
                            : isHovered
                                ? Colors.blue.shade600
                                : Colors.blue.shade700)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPrimary
                          ? Colors.transparent
                          : (isHovered
                              ? Colors.blue.shade500
                              : Colors.blue.shade400),
                      width: isHovered && !isPrimary ? 2 : 1.5,
                    ),
                    boxShadow: [
                      if (isPrimary && isHovered && !isPressed)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                          spreadRadius: 1,
                        )
                      else if (isPrimary && isPressed)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      else if (isPrimary)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                    ],
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isPressed ? 15.5 : 15,
                        fontWeight: FontWeight.w600,
                        color: isPrimary
                            ? Colors.white
                            : Colors.blue.shade700,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 300),
                            turns: isHovered ? 0.02 : 0,
                            child: Icon(
                              icon,
                              size: 20,
                              color: isPrimary
                                  ? Colors.white
                                  : Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(label),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ---------- ANIMATED RECENT ACTIVITY ----------
  Widget _buildAnimatedRecentActivity() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
            ),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? Colors.grey.shade100
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHovered
                          ? Colors.green.shade200
                          : Colors.transparent,
                      width: isHovered ? 1.5 : 0,
                    ),
                  ),
                  child: Row(
                    children: [
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: isHovered ? 0.02 : 0,
                        child: Icon(Icons.check_circle,
                            color: Colors.green.shade600, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last attendance',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isHovered
                                    ? Colors.green.shade800
                                    : Colors.green.shade700,
                              ),
                              child: const Text('Today at 9:30 AM'),
                            ),
                          ],
                        ),
                      ),
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve:
                                const Interval(0.9, 1.0, curve: Curves.elasticOut),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'On Time',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ---------- STATIC VERSIONS (for fallback) ----------
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.school_outlined,
                      size: 12, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    'Computer Science',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCardSimple(
            title: "Total Classes",
            value: "60",
            icon: Icons.school_outlined,
            color: Colors.blue,
          ),
          const SizedBox(width: 10),
          _buildStatCardSimple(
            title: "Attended",
            value: "52",
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          _buildStatCardSimple(
            title: "Percentage",
            value: "87%",
            icon: Icons.trending_up_outlined,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly Attendance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A237E),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '6 Days',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Last week\'s performance',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  minY: 0,
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: 12,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < widget.weekLabels.length) {
                            return Text(
                              widget.weekLabels[index],
                              style: const TextStyle(fontSize: 11),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  barGroups: widget.attendanceValues.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          width: 12,
                          color: value >= 75
                              ? Colors.green
                              : value >= 60
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSimpleLegend(Colors.green, 'Good (≥75%)'),
                const SizedBox(width: 12),
                _buildSimpleLegend(Colors.orange, 'Average (60-74%)'),
                const SizedBox(width: 12),
                _buildSimpleLegend(Colors.red, 'Low (<60%)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MarkAttendanceScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fingerprint, size: 20),
                SizedBox(width: 10),
                Text(
                  'Mark Attendance',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewAttendanceScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.blue.shade400),
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_view_week_outlined,
                    size: 20, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  'View Attendance',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last attendance',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Today at 9:30 AM',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'On Time',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardSimple({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}