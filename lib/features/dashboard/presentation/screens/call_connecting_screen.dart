import 'dart:async';

import 'package:flutter/material.dart';

class CallConnectingScreen extends StatefulWidget {
  const CallConnectingScreen({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isVideoCall,
  });

  final String name;
  final String imagePath;
  final bool isVideoCall;

  @override
  State<CallConnectingScreen> createState() => _CallConnectingScreenState();
}

class _CallConnectingScreenState extends State<CallConnectingScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _elapsedSeconds += 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF210A20),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          child: Stack(
            children: [
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.isVideoCall ? 'Video calling...' : 'Calling...',
                        style: const TextStyle(
                          color: Color(0xFF8D7B8D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF5F0E60),
                          border: Border.all(
                            color: const Color(0xFF76257A),
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isVideoCall
                            ? 'Your video call has started'
                            : 'Your call has started',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF8D7B8D),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _formatTime(_elapsedSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 112,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF646D),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Icon(
                          widget.isVideoCall
                              ? Icons.videocam_off
                              : Icons.call_end,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final String minuteLabel = minutes.toString().padLeft(2, '0');
    final String secondLabel = seconds.toString().padLeft(2, '0');
    return '$minuteLabel:$secondLabel';
  }
}
