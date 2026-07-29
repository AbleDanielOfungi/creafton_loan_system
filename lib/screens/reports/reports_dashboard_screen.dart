// import 'package:creafton_financial_services/providers/reports_provider.dart';
// import 'package:creafton_financial_services/screens/reports/report_filters.dart';
// import 'package:creafton_financial_services/screens/reports/report_header.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ReportsDashboardScreen extends StatefulWidget {
//   const ReportsDashboardScreen({super.key});

//   @override
//   State<ReportsDashboardScreen> createState() => _ReportsDashboardScreenState();
// }

// class _ReportsDashboardScreenState extends State<ReportsDashboardScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ReportsProvider>().loadDashboard();
//     });
//   }

//   Future<void> _refresh() async {
//     await context.read<ReportsProvider>().loadDashboard();
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       appBar: AppBar(
//         title: const Text("Reports Dashboard"),
//         centerTitle: false,
//       ),

//       body: Consumer<ReportsProvider>(
//   builder: (context, provider, child) {

//     if (provider.loading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _refresh,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: const Column(
//           children: [

//             ReportHeader(),

//             SizedBox(height: 20),

//             ReportFilters(),

//           ],
//         ),
//       ),
//     );
//   },
// ),
//     );
//   }
// }
