import 'http_auth_remote_data_source.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> sendOtp({required String phone});
  Future<void> verifyOtp({required String phone, required String otp});
}

class ApiAuthRemoteDataSource implements AuthRemoteDataSource {
  const ApiAuthRemoteDataSource();

  @override
  Future<void> sendOtp({required String phone}) async {
    await ApiService.sendOtp(phone: phone);
  }

  @override
  Future<void> verifyOtp({required String phone, required String otp}) async {
    await ApiService.verifyOtp(phone: phone, otp: otp);
  }
}
