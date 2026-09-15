import '../repositories/auth_repository.dart';

class SendOtp {
  const SendOtp(this._repository);

  final AuthRepository _repository;

  Future<void> call(String phone) => _repository.sendOtp(phone: phone);
}
