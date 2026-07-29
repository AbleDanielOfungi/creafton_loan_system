// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/reports_provider.dart';
// import 'kpi_card.dart';

// class DashboardSummaryGrid extends StatelessWidget {
//   const DashboardSummaryGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ReportsProvider>(
//       builder: (context, provider, child) {
//         final summary = provider.dashboardSummary;

//         if (summary.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         final cards = <Widget>[
//           KpiCard(
//             title: "Total Borrowers",
//             value: "${summary["totalBorrowers"] ?? 0}",
//             icon: Icons.people,
//             color: Colors.blue,
//             subtitle: "Registered borrowers",
//           ),

//           KpiCard(
//             title: "Field Officers",
//             value: "${summary["totalFieldOfficers"] ?? 0}",
//             icon: Icons.badge,
//             color: Colors.indigo,
//             subtitle: "Active officers",
//           ),

//           KpiCard(
//             title: "Guarantors",
//             value: "${summary["totalGuarantors"] ?? 0}",
//             icon: Icons.group,
//             color: Colors.deepPurple,
//             subtitle: "Registered guarantors",
//           ),

//           KpiCard(
//             title: "Total Loans",
//             value: "${summary["totalLoans"] ?? 0}",
//             icon: Icons.account_balance,
//             color: Colors.orange,
//             subtitle: "Loans issued",
//           ),

//           KpiCard(
//             title: "Active Loans",
//             value: "${summary["activeLoans"] ?? 0}",
//             icon: Icons.pending_actions,
//             color: Colors.green,
//             subtitle: "Currently running",
//           ),

//           KpiCard(
//             title: "Completed Loans",
//             value: "${summary["completedLoans"] ?? 0}",
//             icon: Icons.check_circle,
//             color: Colors.teal,
//             subtitle: "Successfully completed",
//           ),

//           KpiCard(
//             title: "Overdue Loans",
//             value: "${summary["overdueLoans"] ?? 0}",
//             icon: Icons.warning_amber,
//             color: Colors.red,
//             subtitle: "Require follow-up",
//           ),

//           KpiCard(
//             title: "Money Lent",
//             value:
//                 "UGX ${(summary["principalLent"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.account_balance_wallet,
//             color: Colors.green,
//             subtitle: "Principal amount",
//           ),

//           KpiCard(
//             title: "Interest Expected",
//             value: "UGX ${(summary["interest"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.percent,
//             color: Colors.orange,
//             subtitle: "Projected interest",
//           ),

//           KpiCard(
//             title: "Total Payable",
//             value:
//                 "UGX ${(summary["totalPayable"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.attach_money,
//             color: Colors.blueGrey,
//             subtitle: "Principal + Interest",
//           ),

//           KpiCard(
//             title: "Collections",
//             value:
//                 "UGX ${(summary["totalCollected"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.payments,
//             color: Colors.lightGreen,
//             subtitle: "Loan repayments",
//           ),

//           KpiCard(
//             title: "Outstanding",
//             value:
//                 "UGX ${(summary["outstandingBalance"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.money_off,
//             color: Colors.red,
//             subtitle: "Remaining balance",
//           ),

//           KpiCard(
//             title: "Today's Collections",
//             value:
//                 "UGX ${(summary["todayCollections"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.today,
//             color: Colors.green,
//             subtitle: "Collected today",
//           ),

//           KpiCard(
//             title: "Today's Expenses",
//             value:
//                 "UGX ${(summary["todayExpenses"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.receipt_long,
//             color: Colors.redAccent,
//             subtitle: "Expenses today",
//           ),

//           KpiCard(
//             title: "Weekly Collections",
//             value:
//                 "UGX ${(summary["weeklyCollections"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.date_range,
//             color: Colors.blue,
//             subtitle: "Current week",
//           ),

//           KpiCard(
//             title: "Monthly Collections",
//             value:
//                 "UGX ${(summary["monthlyCollections"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.calendar_month,
//             color: Colors.indigo,
//             subtitle: "Current month",
//           ),

//           KpiCard(
//             title: "Yearly Collections",
//             value:
//                 "UGX ${(summary["yearlyCollections"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.bar_chart,
//             color: Colors.deepPurple,
//             subtitle: "Current year",
//           ),

//           KpiCard(
//             title: "Total Expenses",
//             value:
//                 "UGX ${(summary["totalExpenses"] ?? 0).toStringAsFixed(0)}",
//             icon: Icons.money,
//             color: Colors.brown,
//             subtitle: "Business expenses",
//           ),
//         ];

//         return LayoutBuilder(
//           builder: (context, constraints) {
//             int crossAxisCount = 6;

//             if (constraints.maxWidth < 1700) {
//               crossAxisCount = 5;
//             }

//             if (constraints.maxWidth < 1450) {
//               crossAxisCount = 4;
//             }

//             if (constraints.maxWidth < 1150) {
//               crossAxisCount = 3;
//             }

//             if (constraints.maxWidth < 800) {
//               crossAxisCount = 2;
//             }

//             return GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),

//               itemCount: cards.length,

//               gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: crossAxisCount,

//                 crossAxisSpacing: 18,

//                 mainAxisSpacing: 18,

//                 childAspectRatio: 1.45,
//               ),

//               itemBuilder: (_, index) => cards[index],
//             );
//           },
//         );
//       },
//     );
//   }
// }