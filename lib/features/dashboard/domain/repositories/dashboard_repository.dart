import '../entities/friend_profile.dart';

abstract interface class DashboardRepository {
  List<FriendProfile> getFriends();
}
