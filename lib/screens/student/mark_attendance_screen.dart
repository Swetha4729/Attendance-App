import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/biometric_service.dart';
import '../../services/wifi_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MarkAttendanceScreen extends StatefulWidget {
  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen>
    with SingleTickerProviderStateMixin {
  final BiometricService _bio = BiometricService();
  final WifiService _wifi = WifiService();
  String? _ssid;
  bool _loading = false;
  String status = '';

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

    _fetchSsid();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchSsid() async {
    final s = await _wifi.getWifiName();
    setState(() => _ssid = s);
  }

  Future<void> _markWithFingerprint() async {
    setState(() { _loading = true; status = 'Authenticating...'; });
    final ok = await _bio.authenticate();
    if (!ok) {
      setState(() { _loading = false; status = 'Biometric authentication failed'; });
      return;
    }

    final token = await AuthService.getToken();
    if (token == null) {
      setState(() { _loading = false; status = 'Token missing'; });
      return;
    }

    try {
      final res = await ApiService.post('/api/attendance/mark', body: {
        'studentId': 'studentIdPlaceholder',
        'method': 'fingerprint',
        'router': _ssid ?? 'unknown'
      }, headers: { 'Authorization': 'Bearer $token' });

      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() { status = 'Attendance marked successfully'; });
      } else {
        setState(() { status = 'Server rejected: ${res.statusCode} ${res.body}'; });
      }
    } catch (e) {
      setState(() { status = 'Error: $e'; });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markWithFace() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (photo == null) return;
    setState(() { _loading = true; status = 'Uploading image...'; });

    final token = await AuthService.getToken();
    if (token == null) {
      setState(() { _loading = false; status = 'Token missing'; });
      return;
    }

    final file = File(photo.path);
    try {
      final streamed = await ApiService.upload('/api/attendance/mark', fields: {
        'studentId': 'studentIdPlaceholder',
        'method': 'face',
        'router': _ssid ?? 'unknown'
      }, file: file, token: token);

      final res = await http.Response.fromStream(streamed);
      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() { status = 'Face attendance success'; });
      } else {
        setState(() { status = 'Server error: ${res.statusCode} ${res.body}'; });
      }
    } catch (e) {
      setState(() { status = 'Upload failed: $e'; });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mark Attendance',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade800,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                    _buildAnimatedNetworkCard(),
                    const SizedBox(height: 32),
                    _buildAnimatedMethodHeader(),
                    const SizedBox(height: 28),
                    _buildAnimatedFingerprintCard(),
                    const SizedBox(height: 20),
                    _buildAnimatedFaceCard(),
                    const SizedBox(height: 32),
                    _buildAnimatedStatusCard(),
                    const SizedBox(height: 24),
                    _buildAnimatedInfoCard(),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNetworkCard(),
                  const SizedBox(height: 32),
                  _buildMethodHeader(),
                  const SizedBox(height: 28),
                  _buildFingerprintCard(),
                  const SizedBox(height: 20),
                  _buildFaceCard(),
                  const SizedBox(height: 32),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildInfoCard(),
                ],
              ),
      ),
    );
  }

  /// ---------- ANIMATED NETWORK CARD ----------
  Widget _buildAnimatedNetworkCard() {
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
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
                  child: Icon(
                    Icons.wifi,
                    color: Colors.blue.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.5, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
                          ),
                          child: Text(
                            'Network Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FadeTransition(
                          opacity: CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
                          ),
                          child: Text(
                            _ssid ?? 'Detecting...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.5, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
                    ),
                  ),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _ssid != null ? Colors.green.shade100 : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _ssid != null ? 'Connected' : 'Scanning',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _ssid != null ? Colors.green.shade800 : Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED METHOD HEADER ----------
  Widget _buildAnimatedMethodHeader() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.3, 0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Authentication Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
                ),
              ),
              child: Text(
                'Select one of the following methods to mark your attendance',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- ANIMATED FINGERPRINT CARD ----------
  Widget _buildAnimatedFingerprintCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
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
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isHovered = false;
              bool isPressed = false;

              return MouseRegion(
                onEnter: (_) {
                  if (!_loading) {
                    setState(() {
                      isHovered = true;
                    });
                  }
                },
                onExit: (_) {
                  setState(() {
                    isHovered = false;
                  });
                },
                cursor: _loading ? SystemMouseCursors.wait : SystemMouseCursors.click,
                child: GestureDetector(
                  onTapDown: (_) {
                    if (!_loading) {
                      setState(() {
                        isPressed = true;
                      });
                    }
                  },
                  onTapUp: (_) {
                    if (!_loading) {
                      setState(() {
                        isPressed = false;
                      });
                      _markWithFingerprint();
                    }
                  },
                  onTapCancel: () {
                    setState(() {
                      isPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isPressed
                            ? [
                                Colors.green.shade200,
                                Colors.green.shade300.withOpacity(0.7),
                              ]
                            : isHovered
                                ? [
                                    Colors.green.shade100,
                                    Colors.green.shade200.withOpacity(0.7),
                                  ]
                                : [
                                    Colors.green.shade50,
                                    Colors.green.shade100.withOpacity(0.7),
                                  ],
                      ),
                      boxShadow: [
                        if (isHovered && !_loading && !isPressed)
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                            spreadRadius: 2,
                          )
                        else if (isPressed)
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ScaleTransition(
                              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0.3, 0.6, curve: Curves.elasticOut),
                                ),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isPressed
                                      ? Colors.green.shade700
                                      : isHovered
                                          ? Colors.green.shade600
                                          : Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 300),
                                  turns: isHovered ? 0.02 : 0,
                                  child: const Icon(
                                    Icons.fingerprint,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.5, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeTransition(
                                      opacity: CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isHovered
                                              ? Colors.green.shade900
                                              : Colors.green.shade800,
                                        ),
                                        child: const Text('Fingerprint Scan'),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    FadeTransition(
                                      opacity: CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isHovered
                                              ? Colors.green.shade700
                                              : Colors.green.shade600,
                                        ),
                                        child: const Text(
                                          'Use your registered fingerprint for quick authentication',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_loading)
                              const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 3,
                                ),
                              )
                            else
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                                  ),
                                ),
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 300),
                                  turns: isHovered ? 0.25 : 0,
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.green.shade800,
                                    size: 28,
                                  ),
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
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED FACE CARD ----------
  Widget _buildAnimatedFaceCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
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
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isHovered = false;
              bool isPressed = false;

              return MouseRegion(
                onEnter: (_) {
                  if (!_loading) {
                    setState(() {
                      isHovered = true;
                    });
                  }
                },
                onExit: (_) {
                  setState(() {
                    isHovered = false;
                  });
                },
                cursor: _loading ? SystemMouseCursors.wait : SystemMouseCursors.click,
                child: GestureDetector(
                  onTapDown: (_) {
                    if (!_loading) {
                      setState(() {
                        isPressed = true;
                      });
                    }
                  },
                  onTapUp: (_) {
                    if (!_loading) {
                      setState(() {
                        isPressed = false;
                      });
                      _markWithFace();
                    }
                  },
                  onTapCancel: () {
                    setState(() {
                      isPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isPressed
                            ? [
                                Colors.blue.shade200,
                                Colors.blue.shade300.withOpacity(0.7),
                              ]
                            : isHovered
                                ? [
                                    Colors.blue.shade100,
                                    Colors.blue.shade200.withOpacity(0.7),
                                  ]
                                : [
                                    Colors.blue.shade50,
                                    Colors.blue.shade100.withOpacity(0.7),
                                  ],
                      ),
                      boxShadow: [
                        if (isHovered && !_loading && !isPressed)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                            spreadRadius: 2,
                          )
                        else if (isPressed)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ScaleTransition(
                              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0.4, 0.7, curve: Curves.elasticOut),
                                ),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isPressed
                                      ? Colors.blue.shade700
                                      : isHovered
                                          ? Colors.blue.shade600
                                          : Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 300),
                                  turns: isHovered ? 0.02 : 0,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.5, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadeTransition(
                                      opacity: CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isHovered
                                              ? Colors.blue.shade900
                                              : Colors.blue.shade800,
                                        ),
                                        child: const Text('Face Recognition'),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    FadeTransition(
                                      opacity: CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                                      ),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 200),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isHovered
                                              ? Colors.blue.shade700
                                              : Colors.blue.shade600,
                                        ),
                                        child: const Text(
                                          'Take a photo for facial recognition verification',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
                                ),
                              ),
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                turns: isHovered ? 0.25 : 0,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Colors.blue.shade800,
                                  size: 28,
                                ),
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
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED STATUS CARD ----------
  Widget _buildAnimatedStatusCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.5, 0),
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
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
                    ),
                  ),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.6, 0.9, curve: Curves.elasticOut),
                          ),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
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
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        status.isEmpty ? 'Ready to mark attendance...' : status,
                        style: TextStyle(
                          fontSize: 15,
                          color: status.contains('success') 
                              ? Colors.green.shade800
                              : status.contains('Error') || status.contains('failed')
                                ? Colors.red.shade700
                                : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_loading)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
                        ),
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.blue.shade100,
                        color: Colors.blue,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- ANIMATED INFO CARD ----------
  Widget _buildAnimatedInfoCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
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
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.amber.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.1),
                  blurRadius: 6,
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
                      curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
                    ),
                  ),
                  child: AnimatedRotation(
                    duration: const Duration(seconds: 5),
                    turns: 1,
                    child: Icon(
                      Icons.security,
                      color: Colors.amber.shade700,
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
                        curve: const Interval(0.9, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                    child: Text(
                      'Attendance is verified using both biometrics and network location for enhanced security.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- STATIC VERSIONS (for fallback) ----------
  Widget _buildNetworkCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi,
            color: Colors.blue.shade700,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Network Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _ssid ?? 'Detecting...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _ssid != null ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _ssid != null ? 'Connected' : 'Scanning',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _ssid != null ? Colors.green.shade800 : Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Authentication Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select one of the following methods to mark your attendance',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFingerprintCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.green.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.green.shade100.withOpacity(0.7),
            ],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _loading ? null : _markWithFingerprint,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fingerprint Scan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Use your registered fingerprint for quick authentication',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 3,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: Colors.green.shade800,
                    size: 28,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaceCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.blue.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100.withOpacity(0.7),
            ],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _loading ? null : _markWithFace,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Face Recognition',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Take a photo for facial recognition verification',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.blue.shade800,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue.shade700,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Text(
              status.isEmpty ? 'Ready to mark attendance...' : status,
              style: TextStyle(
                fontSize: 15,
                color: status.contains('success') 
                    ? Colors.green.shade800
                    : status.contains('Error') || status.contains('failed')
                      ? Colors.red.shade700
                      : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_loading)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: LinearProgressIndicator(
                backgroundColor: Colors.blue.shade100,
                color: Colors.blue,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Attendance is verified using both biometrics and network location for enhanced security.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.amber.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}