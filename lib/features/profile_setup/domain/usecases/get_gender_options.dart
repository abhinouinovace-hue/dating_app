import '../entities/gender_option.dart';
import '../repositories/profile_setup_repository.dart';

class GetGenderOptions {
  const GetGenderOptions(this._repository);

  final ProfileSetupRepository _repository;

  List<GenderOption> call() => _repository.getGenderOptions();
}
