import '../../domain/entities/gender_option.dart';
import '../../domain/entities/language.dart';
import '../../domain/repositories/profile_setup_repository.dart';
import '../datasources/http_profile_setup_remote_data_source.dart';
import '../datasources/profile_setup_local_data_source.dart';

class ProfileSetupRepositoryImpl implements ProfileSetupRepository {
  const ProfileSetupRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final ProfileSetupLocalDataSource _localDataSource;
  final HttpProfileSetupRemoteDataSource _remoteDataSource;

  @override
  List<GenderOption> getGenderOptions() => _localDataSource.getGenderOptions();

  @override
  List<Language> getLanguages() => _localDataSource.getLanguages();

  @override
  Future<void> setupProfile({
    required String name,
    required String gender,
    required String language,
  }) => _remoteDataSource.setupProfile(
    name: name,
    gender: gender,
    language: language,
  );

  @override
  Future<void> updateProfile({
    required String name,
    required String gender,
    required String email,
    required String phone,
    String? dateOfBirth,
  }) => _remoteDataSource.updateProfile(
    name: name,
    gender: gender,
    email: email,
    phone: phone,
    dateOfBirth: dateOfBirth,
  );
}
