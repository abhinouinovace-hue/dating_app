import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<void> sendOtp({required String phone}) => _remoteDataSource.sendOtp(phone: phone);

  @override
  Future<void> verifyOtp({required String phone, required String otp}) =>
      _remoteDataSource.verifyOtp(phone: phone, otp: otp);
}
