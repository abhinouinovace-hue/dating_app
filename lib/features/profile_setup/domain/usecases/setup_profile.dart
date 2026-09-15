import '../repositories/profile_setup_repository.dart';

class SetupProfile {
  const SetupProfile(this._repository);

  final ProfileSetupRepository _repository;

  Future<void> call({
    required String name,
    required String gender,
    required String language,
  }) => _repository.setupProfile(
    name: name,
    gender: gender,
    language: language,
  );
}
