class FriendProfile {
  const FriendProfile({
    required this.name,
    required this.age,
    required this.imagePath,
    required this.rating,
    required this.isVerified,
    required this.canVideoCall,
    required this.canVoiceCall,
  });

  final String name;
  final int age;
  final String imagePath;
  final String rating;
  final bool isVerified;
  final bool canVideoCall;
  final bool canVoiceCall;
}
