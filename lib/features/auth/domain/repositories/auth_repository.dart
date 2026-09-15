abstract interface class AuthRepository {
  Future<void> sendOtp({required String phone});
  Future<void> verifyOtp({required String phone, required String otp});
}
