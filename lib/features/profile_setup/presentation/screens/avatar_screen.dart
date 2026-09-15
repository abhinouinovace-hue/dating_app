import 'dart:async';

import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class AvatarScreen extends StatefulWidget {
  final String name;
  final String language;
  final String gender;

  const AvatarScreen({
    super.key,
    required this.name,
    required this.language,
    required this.gender,
  });

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  final Color yellow = const Color(0xFFE5C43A);

  Timer? timer;

  int currentAvatar = 0;

  final List<String> avatars = [
    '👩',
    '👨',
    '🧕',
    '👩‍🦱',
    '👨‍🦱',
  ];

  @override
  void initState() {
    super.initState();

    // Change avatars while loading
    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) {
        if (!mounted) return;

        setState(() {
          currentAvatar++;

          if (currentAvatar >= avatars.length) {
            currentAvatar = 0;
          }
        });
      },
    );

    // After loading, open welcome page
    Future.delayed(
      const Duration(seconds: 3),
      () {
        timer?.cancel();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
              name: widget.name,
              gender: widget.gender,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Logo at top
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 90,
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Finding an avatar for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Animated avatars
                  SizedBox(
                    height: 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _avatar(
                          avatars[(currentAvatar + 4) % avatars.length],
                          38,
                        ),
                        const SizedBox(width: 8),
                        _avatar(
                          avatars[currentAvatar],
                          55,
                        ),
                        const SizedBox(width: 8),
                        _avatar(
                          avatars[(currentAvatar + 1) % avatars.length],
                          38,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Loading dots
                  const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFE5C43A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String emoji, double size) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Text(
        emoji,
        key: ValueKey(emoji),
        style: TextStyle(
          fontSize: size,
        ),
      ),
    );
  }
}
