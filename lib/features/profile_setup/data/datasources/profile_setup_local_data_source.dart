import '../../domain/entities/gender_option.dart';
import '../../domain/entities/language.dart';

class ProfileSetupLocalDataSource {
  const ProfileSetupLocalDataSource();

  List<Language> getLanguages() => const [
        Language(name: 'Malayalam', nativeName: 'Malayalam'),
        Language(name: 'Tamil', nativeName: 'Tamil'),
        Language(name: 'Kannada', nativeName: 'Kannada'),
        Language(name: 'Hindi', nativeName: 'Hindi'),
        Language(name: 'Telugu', nativeName: 'Telugu'),
        Language(name: 'Marathi', nativeName: 'Marathi'),
      ];

  List<GenderOption> getGenderOptions() => const [
        GenderOption(name: 'Female', imagePath: 'assets/images/female.png'),
        GenderOption(name: 'Male', imagePath: 'assets/images/male.png'),
      ];
}
