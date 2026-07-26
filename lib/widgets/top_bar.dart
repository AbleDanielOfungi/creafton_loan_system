import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

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
          Expanded(
            child: Container(
              height: 40,

              decoration: BoxDecoration(
                color: AppColors.background,

                borderRadius: BorderRadius.circular(12),
              ),

              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search...",

                  prefixIcon: Icon(Icons.search),

                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.notifications_none),
          ),

          const SizedBox(width: 20),

          const CircleAvatar(child: Icon(Icons.person)),

          const SizedBox(width: 10),

          const Column(
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
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class TopBar extends StatelessWidget {
//   const TopBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,

//       color: Colors.white,

//       child: const Center(child: Text("TOP BAR TEST")),
//     );
//   }
// }
