// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/reports_provider.dart';

// class LoanStatisticsChart extends StatefulWidget {
//   const LoanStatisticsChart({super.key});

//   @override
//   State<LoanStatisticsChart> createState() =>
//       _LoanStatisticsChartState();
// }

// class _LoanStatisticsChartState
//     extends State<LoanStatisticsChart> {

//   int selectedChart = 0;

//   @override
//   Widget build(BuildContext context) {

//     return Card(
//       elevation: 2,

//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),

//       child: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Consumer<ReportsProvider>(
//           builder: (context, provider, child) {

//             final summary = provider.dashboardSummary;

//             final active =
//                 (summary["activeLoans"] ?? 0).toDouble();

//             final completed =
//                 (summary["completedLoans"] ?? 0).toDouble();

//             final overdue =
//                 (summary["overdueLoans"] ?? 0).toDouble();

//             final principal =
//                 (summary["principalLent"] ?? 0).toDouble();

//             final collected =
//                 (summary["totalCollected"] ?? 0).toDouble();

//             final outstanding =
//                 (summary["outstandingBalance"] ?? 0).toDouble();

//             return Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,

//               children: [

//                 Row(
//                   children: [

//                     const Icon(
//                       Icons.analytics,
//                       color: Colors.indigo,
//                     ),

//                     const SizedBox(width: 10),

//                     const Text(
//                       "Loan Statistics",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const Spacer(),

//                     ToggleButtons(
//                       borderRadius:
//                           BorderRadius.circular(12),

//                       isSelected: [
//                         selectedChart == 0,
//                         selectedChart == 1,
//                         selectedChart == 2,
//                       ],

//                       onPressed: (index) {
//                         setState(() {
//                           selectedChart = index;
//                         });
//                       },

//                       children: const [

//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           child: Text("Portfolio"),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           child: Text("Status"),
//                         ),

//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           child: Text("Collections"),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),

//                 const SizedBox(height: 30),

//                 SizedBox(
//                   height: 420,

//                   child: AnimatedSwitcher(
//                     duration:
//                         const Duration(milliseconds: 400),

//                     child: selectedChart == 0
//                         ? _portfolioChart(
//                             principal,
//                             collected,
//                             outstanding,
//                           )
//                         : selectedChart == 1
//                             ? _loanStatusChart(
//                                 active,
//                                 completed,
//                                 overdue,
//                               )
//                             : _collectionChart(
//                                 collected,
//                                 outstanding,
//                               ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _portfolioChart(
//     double principal,
//     double collected,
//     double outstanding,
//   ) {
//     return BarChart(

//       BarChartData(

//         gridData: FlGridData(show: true),

//         borderData: FlBorderData(show: false),

//         titlesData: FlTitlesData(

//           leftTitles: AxisTitles(
//             sideTitles:
//                 SideTitles(showTitles: true),
//           ),

//           topTitles: AxisTitles(
//             sideTitles:
//                 SideTitles(showTitles: false),
//           ),

//           rightTitles: AxisTitles(
//             sideTitles:
//                 SideTitles(showTitles: false),
//           ),

//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(

//               showTitles: true,

//               getTitlesWidget:
//                   (value, meta) {

//                 switch (value.toInt()) {

//                   case 0:
//                     return const Text("Lent");

//                   case 1:
//                     return const Text("Collected");

//                   case 2:
//                     return const Text("Balance");

//                 }

//                 return const Text("");
//               },
//             ),
//           ),
//         ),

//         barGroups: [

//           BarChartGroupData(
//             x: 0,
//             barRods: [
//               BarChartRodData(
//                 toY: principal,
//                 width: 30,
//                 color: Colors.blue,
//                 borderRadius:
//                     BorderRadius.circular(8),
//               )
//             ],
//           ),

//           BarChartGroupData(
//             x: 1,
//             barRods: [
//               BarChartRodData(
//                 toY: collected,
//                 width: 30,
//                 color: Colors.green,
//                 borderRadius:
//                     BorderRadius.circular(8),
//               )
//             ],
//           ),

//           BarChartGroupData(
//             x: 2,
//             barRods: [
//               BarChartRodData(
//                 toY: outstanding,
//                 width: 30,
//                 color: Colors.red,
//                 borderRadius:
//                     BorderRadius.circular(8),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _loanStatusChart(
//     double active,
//     double completed,
//     double overdue,
//   ) {

//     return PieChart(

//       PieChartData(

//         centerSpaceRadius: 55,

//         sectionsSpace: 3,

//         sections: [

//           PieChartSectionData(
//             value: active,
//             color: Colors.blue,
//             radius: 90,
//             title: "Active\n${active.toInt()}",
//           ),

//           PieChartSectionData(
//             value: completed,
//             color: Colors.green,
//             radius: 90,
//             title: "Completed\n${completed.toInt()}",
//           ),

//           PieChartSectionData(
//             value: overdue,
//             color: Colors.red,
//             radius: 90,
//             title: "Overdue\n${overdue.toInt()}",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _collectionChart(
//     double collected,
//     double balance,
//   ) {

//     return LineChart(

//       LineChartData(

//         gridData: FlGridData(show: true),

//         borderData: FlBorderData(show: false),

//         titlesData: FlTitlesData(show: false),

//         lineBarsData: [

//           LineChartBarData(

//             isCurved: true,

//             barWidth: 4,

//             color: Colors.green,

//             spots: [

//               FlSpot(0, 0),

//               FlSpot(1, collected * .25),

//               FlSpot(2, collected * .45),

//               FlSpot(3, collected * .70),

//               FlSpot(4, collected),
//             ],
//           ),

//           LineChartBarData(

//             isCurved: true,

//             barWidth: 4,

//             color: Colors.red,

//             spots: [

//               FlSpot(0, balance),

//               FlSpot(1, balance * .85),

//               FlSpot(2, balance * .70),

//               FlSpot(3, balance * .55),

//               FlSpot(4, balance * .40),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }