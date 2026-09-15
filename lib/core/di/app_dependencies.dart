import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/send_otp.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/dashboard/data/datasources/dashboard_local_data_source.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/usecases/get_friends.dart';
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_slides.dart';
import '../../features/profile_setup/data/datasources/profile_setup_local_data_source.dart';
import '../../features/profile_setup/data/datasources/http_profile_setup_remote_data_source.dart';
import '../../features/profile_setup/data/repositories/profile_setup_repository_impl.dart';
import '../../features/profile_setup/domain/usecases/get_gender_options.dart';
import '../../features/profile_setup/domain/usecases/get_languages.dart';
import '../../features/profile_setup/domain/usecases/setup_profile.dart';
import '../../features/profile_setup/domain/usecases/update_profile.dart';

/// The one composition root that connects data implementations to use cases.
abstract final class AppDependencies {
  static final _authRepository = AuthRepositoryImpl(const ApiAuthRemoteDataSource());
  static final sendOtp = SendOtp(_authRepository);
  static final verifyOtp = VerifyOtp(_authRepository);

  static const _onboardingRepository = OnboardingRepositoryImpl(
    OnboardingLocalDataSource(),
  );
  static const getOnboardingSlides = GetOnboardingSlides(_onboardingRepository);

  static const _profileSetupRepository = ProfileSetupRepositoryImpl(
    ProfileSetupLocalDataSource(),
    HttpProfileSetupRemoteDataSource(),
  );
  static const getLanguages = GetLanguages(_profileSetupRepository);
  static const getGenderOptions = GetGenderOptions(_profileSetupRepository);
  static const setupProfile = SetupProfile(_profileSetupRepository);
  static const updateProfile = UpdateProfile(_profileSetupRepository);

  static const _dashboardRepository = DashboardRepositoryImpl(
    DashboardLocalDataSource(),
  );
  static const getFriends = GetFriends(_dashboardRepository);
}
