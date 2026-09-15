import 'package:flutter/material.dart';
import '../../../../core/di/app_dependencies.dart';
import 'avatar_screen.dart';

class GenderScreen extends StatefulWidget {
  final String name;
  final String language;

  const GenderScreen({
    super.key,
    required this.name,
    required this.language,
  });

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final Color purple = const Color(0xFF30002F);
  final Color yellow = const Color(0xFFE5C43A);

  String selectedGender = '';
  bool _isSubmitting = false;
  final _genderOptions = AppDependencies.getGenderOptions();

  Future<void> continueNext() async {
    if (selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your gender'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await AppDependencies.setupProfile(
        name: widget.name,
        gender: selectedGender,
        language: widget.language,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvatarScreen(
            name: widget.name,
            language: widget.language,
            gender: selectedGender,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Image.asset(
                'assets/images/logo.png',
                width: 85,
                height: 45,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: yellow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: yellow,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: yellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 55),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What is your gender?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _genderCard(
                      gender: _genderOptions[0].name,
                      imagePath: _genderOptions[0].imagePath,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _genderCard(
                      gender: _genderOptions[1].name,
                      imagePath: _genderOptions[1].imagePath,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : continueNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5A0B59),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderCard({
    required String gender,
    required String imagePath,
  }) {
    final bool selected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF430442),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? yellow : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 72,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                color: selected ? yellow : Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
