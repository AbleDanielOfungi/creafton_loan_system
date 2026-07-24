import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/dashboard/kpi_card.dart';
import '../../widgets/dashboard/recent_payments.dart';
import '../../widgets/dashboard/collection_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Dashboard",

            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          const Text(
            "Welcome back, Administrator",

            style: TextStyle(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 25),

          Wrap(
            spacing: 20,

            runSpacing: 20,

            children: [
              KPICard(
                title: "Total Borrowers",

                value: "482",

                icon: Icons.people,

                color: AppColors.primaryBlue,
              ),

              KPICard(
                title: "Active Loans",

                value: "315",

                icon: Icons.account_balance_wallet,

                color: AppColors.primaryGreen,
              ),

              KPICard(
                title: "Outstanding",

                value: "UGX 53.5M",

                icon: Icons.money,

                color: AppColors.primaryRed,
              ),

              KPICard(
                title: "Today's Collection",

                value: "UGX 2.4M",

                icon: Icons.payments,

                color: AppColors.success,
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(child: CollectionChart()),

              const SizedBox(width: 20),

              Expanded(child: RecentPayments()),
            ],
          ),
        ],
      ),
    );
  }
}
