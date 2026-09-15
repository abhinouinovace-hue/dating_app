import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color backgroundColor = Color(0xFF1D0A1D);
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFB6AAB6);
  static const Color redColor = Color(0xFFFF5B62);
  static const Color dividerColor = Color(0xFF70206F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // ------------------------------------------------
              // HEADER
              // ------------------------------------------------
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 45,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ------------------------------------------------
              // SETTINGS ITEMS
              // ------------------------------------------------
              _settingsItem(
                icon: Icons.settings_outlined,
                title: 'Reports',
                onTap: () {
                  // Add Reports screen here later
                },
              ),

              _settingsItem(
                icon: Icons.settings_outlined,
                title: 'Violations',
                onTap: () {
                  // Add Violations screen here later
                },
              ),

              _settingsItem(
                icon: Icons.settings_outlined,
                title: 'Blocked Accounts',
                onTap: () {
                  // Add Blocked Accounts screen here later
                },
              ),

              const SizedBox(height: 4),

              // ------------------------------------------------
              // DIVIDER
              // ------------------------------------------------
              Container(
                height: 1,
                color: dividerColor,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),

              // ------------------------------------------------
              // DELETE ACCOUNT
              // ------------------------------------------------
              _settingsItem(
                icon: Icons.settings_outlined,
                title: 'Delete Account',
                isDanger: true,
                onTap: () {
                  _showDeleteConfirmation(context);
                },
              ),

              const Spacer(),

              // ------------------------------------------------
              // VERSION
              // ------------------------------------------------
              const Padding(
                padding: EdgeInsets.only(bottom: 28),
                child: Text(
                  'Version: 512652002',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            SizedBox(
              width: 42,
              child: Icon(
                icon,
                color: isDanger ? redColor : Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(width: 5),

            Text(
              title,
              style: TextStyle(
                color: isDanger ? redColor : primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF29142A),
          title: const Text(
            'Delete Account',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete your account?',
            style: TextStyle(
              color: Color(0xFFB6AAB6),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // Add delete account logic here later
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFFF5B62),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}