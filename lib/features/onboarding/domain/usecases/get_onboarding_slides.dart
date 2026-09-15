import '../entities/onboarding_slide.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingSlides {
  const GetOnboardingSlides(this._repository);

  final OnboardingRepository _repository;

  List<OnboardingSlide> call() => _repository.getSlides();
}
