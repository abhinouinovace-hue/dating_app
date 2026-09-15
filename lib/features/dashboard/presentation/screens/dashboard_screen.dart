import 'package:flutter/material.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../domain/entities/friend_profile.dart';
import '../../domain/services/video_call_room_service.dart';
import 'call_connecting_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

enum _ProfileSheetAction {
  profile,
  settings,
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const String _femaleAvatar = 'assets/images/female.png';
  static const String _maleAvatar = 'assets/images/male.png';

  static const Color _gold = Color(0xFFE0C238);
  static const Color _panelBackground = Color(0xFF1E161D);
  static const Color _panelBorder = Color(0xFF342730);
  static const String _callerName = 'Varun';

  final List<FriendProfile> friends = AppDependencies.getFriends();
  final VideoCallRoomService _videoCallRoomService =
      const VideoCallRoomService();

  /*
    {
      'name': 'Varun',
      'age': 27,
      'image': _maleAvatar,
      'rating': '4.8',
      'verified': true,
      'video': true,
      'voice': true,
    },
    {
      'name': 'Olivia',
      'age': 25,
      'image': _femaleAvatar,
      'rating': '4.8',
      'verified': false,
      'video': true,
      'voice': false,
    },
    {
      'name': 'Liam',
      'age': 22,
      'image': _maleAvatar,
      'rating': '4.8',
      'verified': false,
      'video': true,
      'voice': true,
    },
    {
      'name': 'Mia',
      'age': 24,
      'image': _femaleAvatar,
      'rating': '4.8',
      'verified': false,
      'video': false,
      'voice': true,
    },
    {
      'name': 'Sam',
      'age': 26,
      'image': _maleAvatar,
      'rating': '4.8',
      'verified': false,
      'video': true,
      'voice': true,
    },
  ];
  */

  static const ProfileScreen _profileScreen = ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF170B19),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildMoodSection(),
            Expanded(
              child: _buildFriendsList(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 75,
            height: 45,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF6B0F6A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                Text(
                  '150',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: Color(0xFFE0C238),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: _showProfileSheet,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF6B0F6A),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ClipOval(
                  child: Image.asset(
                    _maleAvatar,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE BOTTOM SHEET
  // ============================================================

  Future<void> _showProfileSheet() async {
    final _ProfileSheetAction? action =
        await showModalBottomSheet<_ProfileSheetAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.92,
          child: Container(
            decoration: const BoxDecoration(
              color: _panelBackground,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      20,
                      12,
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ------------------------------------------------
                        // TOP HANDLE
                        // ------------------------------------------------

                        Center(
                          child: Container(
                            width: 56,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ------------------------------------------------
                        // MY PROFILE
                        // ------------------------------------------------

                        const Text(
                          'My Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 24),

                        _buildProfileHeader(sheetContext),

                        const SizedBox(height: 18),

                        // ------------------------------------------------
                        // COMPLETION
                        // ------------------------------------------------

                        _buildCompletionCard(sheetContext),

                        const SizedBox(height: 14),

                        // ------------------------------------------------
                        // COINS
                        // ------------------------------------------------

                        _buildCoinsCard(),

                        const SizedBox(height: 14),

                        Divider(
                          color: Colors.white.withOpacity(0.08),
                          height: 1,
                        ),

                        const SizedBox(height: 14),

                        // ------------------------------------------------
                        // ACCOUNT SETTING
                        // ------------------------------------------------

                        _buildSectionLabel('Account Setting'),

                        const SizedBox(height: 8),

                        // =================================================
                        // FIXED SETTINGS BUTTON
                        // =================================================

                        _buildSettingTile(
                          Icons.settings_outlined,
                          'Settings',
                          onTap: () {
                            Navigator.of(sheetContext).pop(
                              _ProfileSheetAction.settings,
                            );
                          },
                        ),

                        _buildSettingTile(
                          Icons.dark_mode_outlined,
                          'Dark Mode',
                          onTap: () {
                            // Keep your existing logic here.
                          },
                        ),

                        _buildSettingTile(
                          Icons.language_outlined,
                          'Language Settings',
                          onTap: () {
                            // Keep your existing logic here.
                          },
                        ),

                        const SizedBox(height: 10),

                        // ------------------------------------------------
                        // SUPPORT
                        // ------------------------------------------------

                        _buildSectionLabel('Support'),

                        const SizedBox(height: 8),

                        _buildSettingTile(
                          Icons.support_agent_outlined,
                          'Support',
                          onTap: () {
                            // Keep your existing logic here.
                          },
                        ),

                        _buildLogoutTile(),

                        const SizedBox(height: 14),

                        // ------------------------------------------------
                        // DISCLAIMER
                        // ------------------------------------------------

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'Disclaimer: Never share your phone number. By creating an account, you agree that sharing personal information is at your own risk. Linkr is not liable for any off-platform interactions, harassment, or consequences of conversations between users.',
                            style: TextStyle(
                              color: Color(0xFF8C8189),
                              fontSize: 11,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ------------------------------------------------
                // BOTTOM VERSION BAR
                // ------------------------------------------------

                Container(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    14,
                    12,
                    20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.18),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Linkr',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Version: 512652002',
                        style: TextStyle(
                          color: Color(0xFF9E949C),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

    if (action == _ProfileSheetAction.settings) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _profileScreen,
      ),
    );
  }

  // ============================================================
  // MOOD SECTION
  // ============================================================

  Widget _buildMoodSection() {
    return SizedBox(
      height: 255,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 2,
            child: Column(
              children: const [
                Text(
                  'Not feeling your best?',
                  style: TextStyle(
                    color: Color(0xFFE0C238),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'A conversation can help.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          _ring(
            size: 160,
            color: const Color(0xFF61106A),
            fill: const Color(0xFF220D24),
          ),

          _ring(
            size: 115,
            color: const Color(0xFF73217D),
            fill: const Color(0xFF2A112D),
          ),

          _ring(
            size: 76,
            color: const Color(0xFF8C3493),
            fill: const Color(0xFF331637),
          ),

          Positioned(
            top: 83,
            left: 55,
            child: _orbitAvatar(_femaleAvatar),
          ),

          Positioned(
            top: 82,
            right: 52,
            child: _orbitAvatar(_maleAvatar),
          ),

          Positioned(
            bottom: 24,
            left: 80,
            child: _orbitAvatar(_femaleAvatar),
          ),

          Positioned(
            bottom: 20,
            right: 72,
            child: _orbitAvatar(_maleAvatar),
          ),

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF57D3E3),
                  Color(0xFFEACD69),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.call,
              size: 30,
              color: Color(0xFF3B2146),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring({
    required double size,
    required Color color,
    required Color fill,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 1.2,
        ),
        color: fill,
      ),
    );
  }

  Widget _orbitAvatar(String image) {
    return Container(
      width: 42,
      height: 42,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE0C238),
          width: 1.2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ============================================================
  // FRIENDS LIST
  // ============================================================

  Widget _buildFriendsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return _buildFriendCard(friends[index]);
      },
    );
  }

  Widget _buildFriendCard(FriendProfile friend) {
    return Container(
      height: 102,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF181218),
        border: Border.all(
          color: const Color(0xFF4D3150),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6B0F6A),
                width: 1.2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                friend.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (friend.isVerified)
                  const Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 12,
                        color: Colors.green,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified profile',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Age: ${friend.age}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _callButton(
                      icon: Icons.videocam,
                      enabled: friend.canVideoCall,
                      onTap: () {
                        _openCallScreen(
                          name: friend.name,
                          imagePath: friend.imagePath,
                          isVideoCall: true,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _callButton(
                      icon: Icons.mic,
                      enabled: friend.canVoiceCall,
                      onTap: () {
                        _openCallScreen(
                          name: friend.name,
                          imagePath: friend.imagePath,
                          isVideoCall: false,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF241B22),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    size: 12,
                    color: Color(0xFFE0C238),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    friend.rating,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _callButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 84,
          height: 30,
          decoration: BoxDecoration(
            color: enabled
                ? Colors.transparent
                : const Color(0xFF4A384A),
            border: Border.all(
              color: const Color(0xFF654365),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            icon,
            size: 16,
            color: enabled ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _openCallScreen({
    required String name,
    required String imagePath,
    required bool isVideoCall,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallConnectingScreen(
          name: name,
          imagePath: imagePath,
          isVideoCall: isVideoCall,
          videoCallUrl: isVideoCall
              ? _videoCallRoomService.roomUrlFor(
                  callerName: _callerName,
                  friendName: name,
                )
              : null,
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(BuildContext sheetContext) {
    return Row(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _gold,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              _maleAvatar,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Varun',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                '150 Calls Completed',
                style: TextStyle(
                  color: Color(0xFF938993),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  Navigator.of(sheetContext).pop(
                    _ProfileSheetAction.profile,
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'View Full Profile',
                      style: TextStyle(
                        color: Color(0xFF39D353),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFF39D353),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // COMPLETION CARD
  // ============================================================

  Widget _buildCompletionCard(BuildContext sheetContext) {
    return GestureDetector(
      onTap: () {
        Navigator.of(sheetContext).pop(
          _ProfileSheetAction.profile,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 38,
              height: 38,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 0.67,
                    strokeWidth: 4,
                    backgroundColor: Color(0x66FFFFFF),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(
                      Color(0xFF7E2EC6),
                    ),
                  ),
                  Text(
                    '67%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                'Just a few more details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COINS
  // ============================================================

  Widget _buildCoinsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF281E27),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _panelBorder,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Coins',
                  style: TextStyle(
                    color: Color(0xFFA0969E),
                    fontSize: 12,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '1,052',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: _gold,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Recharge Now',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION LABEL
  // ============================================================

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF857A83),
        fontSize: 13,
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget _buildLogoutTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Keep existing logout logic.
          },
          borderRadius: BorderRadius.circular(12),
          child: const SizedBox(
            width: double.infinity,
            height: 52,
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFFF5F5F),
                  size: 20,
                ),

                SizedBox(width: 14),

                Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFFF5F5F),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
