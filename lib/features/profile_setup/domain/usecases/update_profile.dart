import '../repositories/profile_setup_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final ProfileSetupRepository _repository;

  Future<void> call({
    required String name,
    required String gender,
    required String email,
    required String phone,
    String? dateOfBirth,
  }) => _repository.updateProfile(
    name: name,
    gender: gender,
    email: email,
    phone: phone,
    dateOfBirth: dateOfBirth,
  );
}
