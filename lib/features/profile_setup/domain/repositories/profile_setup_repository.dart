import '../entities/gender_option.dart';
import '../entities/language.dart';

abstract interface class ProfileSetupRepository {
  List<Language> getLanguages();
  List<GenderOption> getGenderOptions();
  Future<void> setupProfile({
    required String name,
    required String gender,
    required String language,
  });

  Future<void> updateProfile({
    required String name,
    required String gender,
    required String email,
    required String phone,
    String? dateOfBirth,
  });
}
