// import 'package:creafton_financial_services/providers/reports_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';



// class ReportSummaryCards extends StatelessWidget {
//   const ReportSummaryCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ReportProvider>(
//       builder: (context, provider, child) {
//         final summary = provider.summary;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Executive Summary",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 20),

//             Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               children: [
//                 _SummaryCard(
//                   title: "Borrowers",
//                   value: summary.totalBorrowers.toString(),
//                   icon: Icons.people_alt_outlined,
//                   color: Colors.blue,
//                 ),

//                 _SummaryCard(
//                   title: "Active Borrowers",
//                   value: summary.activeBorrowers.toString(),
//                   icon: Icons.person_outline,
//                   color: Colors.green,
//                 ),

//                 _SummaryCard(
//                   title: "Total Loans",
//                   value: summary.totalLoans.toString(),
//                   icon: Icons.account_balance_wallet_outlined,
//                   color: Colors.orange,
//                 ),

//                 _SummaryCard(
//                   title: "Active Loans",
//                   value: summary.activeLoans.toString(),
//                   icon: Icons.trending_up,
//                   color: Colors.teal,
//                 ),

//                 _SummaryCard(
//                   title: "Completed Loans",
//                   value: summary.completedLoans.toString(),
//                   icon: Icons.check_circle_outline,
//                   color: Colors.indigo,
//                 ),

//                 _SummaryCard(
//                   title: "Portfolio",
//                   value: _currency(summary.totalPortfolio),
//                   icon: Icons.account_balance,
//                   color: Colors.deepPurple,
//                 ),

//                 _SummaryCard(
//                   title: "Collected",
//                   value: _currency(summary.totalCollected),
//                   icon: Icons.payments_outlined,
//                   color: Colors.green,
//                 ),

//                 _SummaryCard(
//                   title: "Outstanding",
//                   value: _currency(summary.outstandingBalance),
//                   icon: Icons.warning_amber_outlined,
//                   color: Colors.red,
//                 ),

//                 _SummaryCard(
//                   title: "Today's Collections",
//                   value: _currency(summary.todayCollections),
//                   icon: Icons.today,
//                   color: Colors.lightGreen,
//                 ),

//                 _SummaryCard(
//                   title: "Monthly Collections",
//                   value: _currency(summary.monthlyCollections),
//                   icon: Icons.calendar_month,
//                   color: Colors.blueAccent,
//                 ),

//                 _SummaryCard(
//                   title: "Expenses",
//                   value: _currency(summary.totalExpenses),
//                   icon: Icons.money_off_csred_outlined,
//                   color: Colors.deepOrange,
//                 ),

//                 _SummaryCard(
//                   title: "Net Income",
//                   value: _currency(summary.netIncome),
//                   icon: Icons.savings_outlined,
//                   color: summary.netIncome >= 0
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   static String _currency(double value) {
//     final formatter = NumberFormat.currency(
//       locale: "en_US",
//       symbol: "UGX ",
//       decimalDigits: 0,
//     );

//     return formatter.format(value);
//   }
// }

// class _SummaryCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const _SummaryCard({
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 240,
//       child: Card(
//         elevation: 2,
//         shadowColor: color.withOpacity(.15),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(18),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 26,
//                 backgroundColor: color.withOpacity(.12),
//                 child: Icon(
//                   icon,
//                   color: color,
//                   size: 28,
//                 ),
//               ),

//               const SizedBox(width: 16),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 13,
//                       ),
//                     ),

//                     const SizedBox(height: 6),

//                     Text(
//                       value,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }