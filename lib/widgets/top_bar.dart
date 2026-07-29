import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../screens/auth/login_screen.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    //------------------------------------------------------------------
    // TODO:
    // Clear logged-in user/session here.
    //
    // Example:
    //
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove("logged_in_user");
    //------------------------------------------------------------------

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Spacer(),

          IconButton(
            tooltip: "Notifications",
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),

          const SizedBox(width: 20),
          PopupMenuButton<String>(
            offset: const Offset(0, 55),
            onSelected: (value) async {
              if (value == "logout") {
                await _logout(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: const Row(
              children: [
                CircleAvatar(radius: 20, child: Icon(Icons.person)),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Administrator",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Admin Account"),
                  ],
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
