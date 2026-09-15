import 'dart:async';

import 'package:flutter/material.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final String name;
  final String gender;

  const WelcomeScreen({
    super.key,
    required this.name,
    required this.gender,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Show Welcome screen for 2 seconds,
    // then automatically open Dashboard.
    _timer = Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) {
              return const DashboardScreen();
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String genderImagePath = widget.gender == 'Male'
        ? 'assets/images/male.png'
        : 'assets/images/female.png';

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              // -----------------------------
              // LOGO
              // -----------------------------
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 90,
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 25),

              // -----------------------------
              // WELCOME USER
              // -----------------------------
              Row(
                children: [

                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        genderImagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    'Welcome ${widget.name.isEmpty ? 'there' : widget.name},',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // -----------------------------
              // MESSAGE
              // -----------------------------
              const Text(
                'Start chat with your new\nfriends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              // -----------------------------
              // LOADING INDICATOR
              // -----------------------------
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      Color(0xFFE5C43A),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
