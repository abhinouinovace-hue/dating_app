import '../../domain/entities/onboarding_slide.dart';

class OnboardingLocalDataSource {
  const OnboardingLocalDataSource();

  List<OnboardingSlide> getSlides() => const [
        OnboardingSlide(
          imagePath: 'assets/images/onboarding_1.png',
          title: 'Find your link. Start real conversations.',
        ),
        OnboardingSlide(
          imagePath: 'assets/images/onboarding_2.png',
          title: 'Meet people who match your vibe.',
        ),
        OnboardingSlide(
          imagePath: 'assets/images/onboarding_3.png',
          title: 'Make connections that feel real.',
        ),
      ];
}
