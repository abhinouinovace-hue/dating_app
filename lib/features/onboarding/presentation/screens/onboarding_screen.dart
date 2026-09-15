import 'package:flutter/material.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../domain/entities/onboarding_slide.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<OnboardingSlide> _slides = AppDependencies.getOnboardingSlides();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ------------------------------------------------
  // NEXT ONBOARDING PAGE
  // ------------------------------------------------
  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  // ------------------------------------------------
  // GET STARTED -> LOGIN
  // FADE / OPACITY TRANSITION ONLY
  // NO SLIDE TRANSITION
  // ------------------------------------------------
  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),

        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return const LoginScreen();
        },

        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _pageController,
        itemCount: _slides.length,

        // Swipe between onboarding screens
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },

        itemBuilder: (context, index) {
          return _buildOnboardingPage(
            context,
            index,
            screenSize,
          );
        },
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    int index,
    Size screenSize,
  ) {
    final bool isLastPage = index == _slides.length - 1;

    return Padding(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ------------------------------------------------
            // BACKGROUND IMAGE
            // ------------------------------------------------
            Image.asset(
              _slides[index].imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFF5F5F5),
                  alignment: Alignment.center,
                  child: const Text(
                    'Image not found',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),

            // ------------------------------------------------
            // DARK GRADIENT
            // ------------------------------------------------
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                  stops: const [
                    0.0,
                    0.35,
                    0.65,
                    1.0,
                  ],
                ),
              ),
            ),

            // ------------------------------------------------
            // CONTENT
            // ------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------------------------------
                  // PROGRESS INDICATORS
                  // ------------------------------------------
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Row(
                      children: List.generate(
                        _slides.length,
                        (progressIndex) {
                          final bool isActive =
                              progressIndex == _currentPage;

                          return Expanded(
                            child: Container(
                              height: 5,
                              margin: EdgeInsets.only(
                                right: progressIndex ==
                                        _slides.length - 1
                                    ? 0
                                    : 12,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFFE0C238)
                                    : Colors.grey.shade600,
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 42),

                  // ------------------------------------------
                  // TITLE
                  // ------------------------------------------
                  Text(
                    _slides[index].title,
                    style: const TextStyle(
                      color: Color(0xFF561052),
                      fontSize: 34,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),

                  const Spacer(),

                  // ------------------------------------------
                  // BUTTON
                  // ------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 68,
                    child: ElevatedButton(
                      onPressed: isLastPage
                          ? _goToLogin
                          : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE0C238),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        isLastPage
                            ? 'Get Started'
                            : 'Continue',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
