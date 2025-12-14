import 'package:flutter/material.dart';

class ModifyAttendanceScreen extends StatefulWidget {
  const ModifyAttendanceScreen({super.key});

  @override
  State<ModifyAttendanceScreen> createState() =>
      _ModifyAttendanceScreenState();
}

class _ModifyAttendanceScreenState extends State<ModifyAttendanceScreen>
    with SingleTickerProviderStateMixin {
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
  
  late AnimationController _animationController;
  bool _isAnimationInitialized = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller immediately
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Mark animation as initialized
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

  Animation<double> get _fadeAnimation => Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ),
  );

  Animation<double> get _slideAnimation => Tween<double>(begin: 30.0, end: 0.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ),
  );

  Animation<double> get _scaleAnimation => Tween<double>(begin: 0.9, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ),
  );

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
              child: _buildContent(),
            )
          : _buildContent(), // Show static content while animating
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClassHeader(),
          const SizedBox(height: 20),
          _buildAnimatedInstruction(),
          const SizedBox(height: 12),
          Expanded(child: _buildStudentList()),
          _buildSaveButton(),
        ],
      ),
    );
  }

  /// ---------- ANIMATED INSTRUCTION ----------
  Widget _buildAnimatedInstruction() {
    if (!_isAnimationInitialized) {
      return const Text(
        'Tap the status button to modify attendance',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      );
    }
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
        ),
        child: const Text(
          'Tap the status button to modify attendance',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// ---------- CLASS HEADER ----------
  Widget _buildClassHeader() {
    if (!_isAnimationInitialized) {
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
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.1, 0.5, curve: Curves.elasticOut),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.1, 0.4, curve: Curves.elasticOut),
                    ),
                  ),
                  child: Icon(Icons.class_, color: Colors.orange.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
                        ),
                        child: Text(
                          className,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
                        ),
                        child: Text(
                          subjectName,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
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
    );
  }

  /// ---------- STUDENT LIST ----------
  Widget _buildStudentList() {
    return ListView.separated(
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final student = students[index];
        
        // Staggered animation delay
        double delay = 0.4 + (index * 0.15);
        delay = delay.clamp(0.0, 1.0);
        
        return _buildAnimatedStudentTile(index, student, delay);
      },
    );
  }

  /// ---------- ANIMATED STUDENT TILE ----------
  Widget _buildAnimatedStudentTile(int index, Map<String, String> student, double delay) {
    Color statusColor = _getStatusColor(student["status"]!);
    
    // If animation not initialized yet, show static version
    if (!_isAnimationInitialized) {
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
    
    double endDelay = (delay + 0.3).clamp(0.0, 1.0);
    
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
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isHovered ? Colors.grey.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHovered ? statusColor.withOpacity(0.3) : Colors.grey.shade300,
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
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(delay + 0.1, endDelay, curve: Curves.elasticOut),
                          ),
                        ),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          scale: isHovered ? 1.1 : 1.0,
                          child: CircleAvatar(
                            backgroundColor: statusColor.withOpacity(
                              isHovered ? 0.2 : 0.15
                            ),
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 300),
                              turns: isHovered ? 0.02 : 0,
                              child: Text(
                                student["name"]![0],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(delay + 0.15, endDelay, curve: Curves.easeIn),
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isHovered ? Colors.indigo.shade800 : Colors.black,
                                ),
                                child: Text(student["name"]!),
                              ),
                            ),
                            const SizedBox(height: 2),
                            FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(delay + 0.2, endDelay, curve: Curves.easeIn),
                              ),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isHovered ? Colors.indigo.shade600 : Colors.grey,
                                ),
                                child: Text(student["roll"]!),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      /// --------- COLORED STATUS DROPDOWN ----------
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(delay + 0.25, endDelay, curve: Curves.elasticOut),
                          ),
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            bool isDropdownHovered = false;
                            
                            return MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  isDropdownHovered = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  isDropdownHovered = false;
                                });
                              },
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDropdownHovered 
                                        ? statusColor.withOpacity(0.5)
                                        : Colors.transparent,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: student["status"],
                                    icon: AnimatedRotation(
                                      duration: const Duration(milliseconds: 200),
                                      turns: isDropdownHovered ? 0.5 : 0,
                                      child: Icon(
                                        Icons.arrow_drop_down, 
                                        color: statusColor,
                                        size: isDropdownHovered ? 26 : 24,
                                      ),
                                    ),
                                    dropdownColor: Colors.white,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                    items: statusOptions.map((status) {
                                      Color itemColor = _getStatusColor(status);
                                      return DropdownMenuItem<String>(
                                        value: status,
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            bool isItemHovered = false;
                                            
                                            return MouseRegion(
                                              onEnter: (_) {
                                                setState(() {
                                                  isItemHovered = true;
                                                });
                                              },
                                              onExit: (_) {
                                                setState(() {
                                                  isItemHovered = false;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 150),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isItemHovered 
                                                      ? itemColor.withOpacity(0.1)
                                                      : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                    color: itemColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: isItemHovered ? 15 : 14,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
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
                              ),
                            );
                          },
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

  /// ---------- ANIMATED SAVE BUTTON ----------
  Widget _buildSaveButton() {
    if (!_isAnimationInitialized) {
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
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: StatefulBuilder(
              builder: (context, setState) {
                bool isButtonHovered = false;
                bool isButtonPressed = false;
                
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isButtonHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isButtonHovered = false;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        isButtonPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isButtonPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        isButtonPressed = false;
                      });
                    },
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Attendance updated successfully'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 50,
                      decoration: BoxDecoration(
                        color: isButtonPressed
                            ? Colors.orange.shade700
                            : isButtonHovered
                                ? Colors.orange.shade600
                                : Colors.orange.shade500,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (isButtonHovered && !isButtonPressed)
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                              spreadRadius: 1,
                            )
                          else if (isButtonPressed)
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          else
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: isButtonPressed ? 15.5 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                turns: isButtonHovered ? 0.02 : 0,
                                child: const Icon(
                                  Icons.save,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Save Changes'),
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