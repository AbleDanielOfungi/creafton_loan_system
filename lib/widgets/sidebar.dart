import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class Sidebar extends StatelessWidget {
  final bool collapsed;

  final VoidCallback onToggle;

  final Function(String) onMenuSelected;

  const Sidebar({
    super.key,

    required this.collapsed,

    required this.onToggle,

    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),

      width: collapsed ? 80 : 260,

      color: Colors.white,

      child: Column(
        children: [
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.account_balance,

                color: AppColors.primaryBlue,

                size: 32,
              ),

              if (!collapsed) const SizedBox(width: 10),

              if (!collapsed)
                const Text(
                  "CREAFTON",

                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
            ],
          ),

          const SizedBox(height: 40),

          Expanded(
            child: ListView(
              children: [
                _menu(Icons.dashboard, "Dashboard"),

                _menu(Icons.people, "Borrowers"),

                _menu(Icons.badge, "Field Officers"),

                _menu(Icons.money, "Loans"),

                _menu(Icons.payment, "Payments"),

                _menu(Icons.bar_chart, "Reports"),

                _menu(Icons.settings, "Settings"),
              ],
            ),
          ),

          IconButton(
            onPressed: onToggle,

            icon: Icon(
              collapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _menu(IconData icon, String title) {
  //   return ListTile(
  //     leading: Icon(icon, color: AppColors.primaryBlue),

  //     title: collapsed
  //         ? null
  //         : Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

  //     hoverColor: AppColors.background,

  //     onTap: () {
  //       onMenuSelected(title);
  //     },
  //   );
  // }

  Widget _menu(IconData icon, String title) {
    return Material(
      color: Colors.transparent,

      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryBlue),

        title: collapsed
            ? null
            : Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),

        hoverColor: AppColors.background,

        onTap: () {
          onMenuSelected(title);
        },
      ),
    );
  }
}
