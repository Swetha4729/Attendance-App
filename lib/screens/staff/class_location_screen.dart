import 'package:flutter/material.dart';

class ClassLocationScreen extends StatefulWidget {
  const ClassLocationScreen({super.key});

  @override
  State<ClassLocationScreen> createState() => _ClassLocationScreenState();
}

class _ClassLocationScreenState extends State<ClassLocationScreen>
    with SingleTickerProviderStateMixin {
  String selectedClass = "CSE – III A";
  String selectedSubject = "Data Structures";

  String roomNumber = "A403";
  String wifiSSID = "MCET-A403";

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
          'Class Location Setup',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedClassAndSubjectCard(),
                    const SizedBox(height: 20),
                    _buildAnimatedRoomAndWifiCard(),
                    const SizedBox(height: 30),
                    _buildAnimatedSaveButton(),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClassAndSubjectCard(),
                  const SizedBox(height: 20),
                  _buildRoomAndWifiCard(),
                  const SizedBox(height: 30),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  /// ---------- ANIMATED CLASS & SUBJECT CARD ----------
  Widget _buildAnimatedClassAndSubjectCard() {
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
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
                  ),
                  child: const Text(
                    'Class Details',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedDropdown(
                  label: "Class",
                  value: selectedClass,
                  items: classes,
                  onChanged: (val) => setState(() => selectedClass = val),
                  delay: 0.3,
                ),
                const SizedBox(height: 12),
                _buildAnimatedDropdown(
                  label: "Subject",
                  value: selectedSubject,
                  items: subjects,
                  onChanged: (val) => setState(() => selectedSubject = val),
                  delay: 0.4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED ROOM & WIFI CARD ----------
  Widget _buildAnimatedRoomAndWifiCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
                  ),
                  child: const Text(
                    'Class Location (Wi-Fi Based)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                _buildAnimatedTextField(
                  label: 'Room Number (eg: A403, C127)',
                  initialValue: roomNumber,
                  onChanged: (val) => roomNumber = val,
                  icon: Icons.location_on,
                  delay: 0.4,
                ),
                const SizedBox(height: 14),
                _buildAnimatedTextField(
                  label: 'Allowed Wi-Fi Router Name (SSID)',
                  initialValue: wifiSSID,
                  onChanged: (val) => wifiSSID = val,
                  icon: Icons.wifi,
                  delay: 0.5,
                  helperText:
                      'Only students connected to this Wi-Fi can mark attendance',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED TEXT FIELD ----------
  Widget _buildAnimatedTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    required IconData icon,
    required double delay,
    String? helperText,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.3, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Interval(delay, delay + 0.3, curve: Curves.easeIn),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            bool isFocused = false;

            return Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  isFocused = hasFocus;
                });
              },
              child: TextFormField(
                initialValue: initialValue,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    color: isFocused ? Colors.green.shade700 : Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.green.shade700,
                      width: 2,
                    ),
                  ),
                  prefixIcon: AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isFocused ? 0.02 : 0,
                    child: Icon(
                      icon,
                      color: isFocused
                          ? Colors.green.shade700
                          : Colors.grey.shade600,
                    ),
                  ),
                  helperText: helperText,
                  helperStyle: const TextStyle(fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: onChanged,
              ),
            );
          },
        ),
      ),
    );
  }

 /// ---------- ANIMATED DROPDOWN ----------
Widget _buildAnimatedDropdown({
  required String label,
  required String value,
  required List<String> items,
  required Function(String) onChanged,
  required double delay,
}) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(delay, delay + 0.3, curve: Curves.easeOut),
      ),
    ),
    child: FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(delay, delay + 0.3, curve: Curves.easeIn),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          bool isHovered = false;
          bool isExpanded = false;

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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isHovered
                      ? Colors.indigo.shade300
                      : Colors.grey.shade400,
                  width: isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  if (isHovered)
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  hoverColor: Colors.indigo.shade50,
                ),
                child: DropdownButtonFormField<String>(
                  value: value,
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(
                      color: Colors.indigo.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        label == "Class" ? Icons.class_ : Icons.subject,
                        color: Colors.indigo.shade600,
                        size: 20,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: Colors.indigo.shade900,  // Darker color for better visibility
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  isExpanded: true,  // Important: Makes dropdown take full width
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: Colors.indigo.shade800,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      onChanged(val);
                    }
                  },
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.indigo.shade700,
                        size: 24,
                      ),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  menuMaxHeight: 300,
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

    /// ---------- ANIMATED SAVE BUTTON ----------
    Widget _buildAnimatedSaveButton() {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
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
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
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
                            content: Text(
                              'Location set for $selectedClass ($roomNumber)',
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 6,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 50,
                        decoration: BoxDecoration(
                          color: isButtonPressed
                              ? Colors.indigo.shade700
                              : isButtonHovered
                                  ? Colors.indigo.shade600
                                  : Colors.indigo.shade500,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            if (isButtonHovered && !isButtonPressed)
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: 1,
                              )
                            else if (isButtonPressed)
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            else
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.2),
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
                                const Text('Save Class Location'),
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

  /// ---------- STATIC VERSIONS (for fallback) ----------
  Widget _buildClassAndSubjectCard() {
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
            'Class Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
        ],
      ),
    );
  }

  Widget _buildRoomAndWifiCard() {
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
            'Class Location (Wi-Fi Based)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: roomNumber,
            decoration: const InputDecoration(
              labelText: 'Room Number (eg: A403, C127)',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => roomNumber = val,
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: wifiSSID,
            decoration: const InputDecoration(
              labelText: 'Allowed Wi-Fi Router Name (SSID)',
              border: OutlineInputBorder(),
              helperText:
                  'Only students connected to this Wi-Fi can mark attendance',
            ),
            onChanged: (val) => wifiSSID = val,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location set for $selectedClass ($roomNumber)',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Save Class Location',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

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
}