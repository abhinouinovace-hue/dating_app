import '../../domain/entities/friend_profile.dart';

class DashboardLocalDataSource {
  const DashboardLocalDataSource();

  List<FriendProfile> getFriends() => const [
        FriendProfile(
          name: 'Varun', age: 27, imagePath: 'assets/images/male.png', rating: '4.8',
          isVerified: true, canVideoCall: true, canVoiceCall: true,
        ),
        FriendProfile(
          name: 'Olivia', age: 25, imagePath: 'assets/images/female.png', rating: '4.8',
          isVerified: false, canVideoCall: true, canVoiceCall: false,
        ),
        FriendProfile(
          name: 'Liam', age: 22, imagePath: 'assets/images/male.png', rating: '4.8',
          isVerified: false, canVideoCall: true, canVoiceCall: true,
        ),
        FriendProfile(
          name: 'Mia', age: 24, imagePath: 'assets/images/female.png', rating: '4.8',
          isVerified: false, canVideoCall: false, canVoiceCall: true,
        ),
        FriendProfile(
          name: 'Sam', age: 26, imagePath: 'assets/images/male.png', rating: '4.8',
          isVerified: false, canVideoCall: true, canVoiceCall: true,
        ),
      ];
}
