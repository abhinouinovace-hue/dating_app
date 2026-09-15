import '../entities/friend_profile.dart';
import '../repositories/dashboard_repository.dart';

class GetFriends {
  const GetFriends(this._repository);

  final DashboardRepository _repository;

  List<FriendProfile> call() => _repository.getFriends();
}
