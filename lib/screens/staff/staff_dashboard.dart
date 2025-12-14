import 'package:flutter/material.dart';

// Import target screens
import 'view_attendance_staff.dart';
import 'modify_attendance_screen.dart';
import 'class_location_screen.dart';
import 'attendance_reports.dart';
import '../auth/login_screen.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({super.key});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideUpAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideUpAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLogoutPressed(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (route) => false,
    );
  }

  void _onActionCardPressed(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.fastOutSlowIn;
          
          var scaleTween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var fadeTween = Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: ScaleTransition(
              scale: animation.drive(scaleTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staff Dashboard',
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
              onPressed: () => _onLogoutPressed(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideUpAnimation.value),
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
                /// Header with slide animation
                SlideTransition(
                  position: _headerSlideAnimation,
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
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
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.indigo.shade700,
                            child: const Text(
                              'S',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                              children: const [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Dr. Smith',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Computer Science Department',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
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

                /// Stats with staggered animation
                Row(
                  children: [
                    _buildAnimatedStatCard('Classes', '5', Icons.class_, 0),
                    const SizedBox(width: 10),
                    _buildAnimatedStatCard('Students', '180', Icons.people, 1),
                    const SizedBox(width: 10),
                    _buildAnimatedStatCard('Today', '3', Icons.today, 2),
                  ],
                ),

                const SizedBox(height: 30),

                /// Quick Actions Title
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
                    ),
                    child: const Text(
                      'Quick Actions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                /// Animated Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildAnimatedActionCard(
                      context: context,
                      icon: Icons.visibility,
                      title: 'View Attendance',
                      subtitle: 'Class & student wise',
                      color: Colors.blue,
                      page: const ViewAttendanceStaff(),
                      index: 0,
                    ),
                    _buildAnimatedActionCard(
                      context: context,
                      icon: Icons.edit_calendar,
                      title: 'Modify Attendance',
                      subtitle: 'Edit records',
                      color: Colors.orange,
                      page: const ModifyAttendanceScreen(),
                      index: 1,
                    ),
                    _buildAnimatedActionCard(
                      context: context,
                      icon: Icons.location_on,
                      title: 'Set Class Location',
                      subtitle: 'Room based (A403, C127)',
                      color: Colors.green,
                      page: const ClassLocationScreen(),
                      index: 2,
                    ),
                    _buildAnimatedActionCard(
                      context: context,
                      icon: Icons.bar_chart,
                      title: 'Reports',
                      subtitle: 'Download & analyze',
                      color: Colors.purple,
                      page: const AttendanceReports(),
                      index: 3,
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Animated Stat Card
  Widget _buildAnimatedStatCard(String title, String value, IconData icon, int index) {
    double start = 0.4 + (index * 0.1);
    double end = start + 0.3;
    
    // Ensure end doesn't exceed 1.0
    if (end > 1.0) end = 1.0;
    if (start > 1.0) start = 1.0;

    return Expanded(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(start, end, curve: Curves.elasticOut),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Icon(icon, color: Colors.indigo.shade700),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Animated Clickable Action Card
  Widget _buildAnimatedActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
    required int index,
  }) {
    double baseStart = 0.6;
    int row = index ~/ 2;
    int col = index % 2;
    double start = baseStart + (row * 0.15) + (col * 0.1);
    double end = start + 0.4;
    
    // Clamp values between 0.0 and 1.0
    start = start.clamp(0.0, 1.0);
    end = end.clamp(0.0, 1.0);
    
    // Ensure start is less than end
    if (start >= end) {
      end = start + 0.1;
      if (end > 1.0) {
        end = 1.0;
        start = 0.9;
      }
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.7),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(start, end, curve: Curves.elasticOut),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _onActionCardPressed(context, page),
            splashColor: color.withOpacity(0.2),
            highlightColor: color.withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon animation - starts slightly later
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          (start + 0.1).clamp(0.0, 1.0),
                          (end + 0.1).clamp(0.0, 1.0),
                          curve: Curves.elasticOut,
                        ),
                      ),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const Spacer(),
                  // Title animation - starts slightly later
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (start + 0.2).clamp(0.0, 1.0),
                        (end + 0.2).clamp(0.0, 1.0),
                        curve: Curves.easeIn,
                      ),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle animation - starts slightly later
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        (start + 0.3).clamp(0.0, 1.0),
                        (end + 0.3).clamp(0.0, 1.0),
                        curve: Curves.easeIn,
                      ),
                    ),
                    child: Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
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
}