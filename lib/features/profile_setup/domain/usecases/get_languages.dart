import '../entities/language.dart';
import '../repositories/profile_setup_repository.dart';

class GetLanguages {
  const GetLanguages(this._repository);

  final ProfileSetupRepository _repository;

  List<Language> call() => _repository.getLanguages();
}
