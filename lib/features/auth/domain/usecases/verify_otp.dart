import '../repositories/auth_repository.dart';

class VerifyOtp {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String phone, required String otp}) =>
      _repository.verifyOtp(phone: phone, otp: otp);
}
