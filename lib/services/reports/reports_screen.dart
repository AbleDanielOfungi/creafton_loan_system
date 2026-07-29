// import 'package:creafton_financial_services/providers/reports_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ReportProvider>().loadReport();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ReportProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           backgroundColor: const Color(0xffF5F7FA),

//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black87,
//             title: const Text(
//               "Reports & Analytics",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             actions: [
//               IconButton(
//                 tooltip: "Refresh",
//                 onPressed: provider.loading
//                     ? null
//                     : provider.refresh,
//                 icon: const Icon(Icons.refresh),
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),

//           body: Column(
//             children: [

//               //--------------------------------------------
//               // Toolbar
//               //--------------------------------------------

//               _buildToolbar(provider),

//               //--------------------------------------------
//               // Main Content
//               //--------------------------------------------

//               Expanded(
//                 child: provider.loading
//                     ? const Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : provider.error != null
//                         ? _buildError(provider)
//                         : SingleChildScrollView(
//                             padding: const EdgeInsets.all(20),
//                             child: Column(
//                               crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                               children: [

//                                 //--------------------------------
//                                 // Filters
//                                 //--------------------------------

//                                 _placeholderCard(
//                                   title: "Filters",
//                                   icon: Icons.filter_alt_outlined,
//                                   message:
//                                       "Step 10.3.4.2 will be inserted here.",
//                                 ),

//                                 const SizedBox(height: 20),

//                                 //--------------------------------
//                                 // Summary
//                                 //--------------------------------

//                                 _placeholderCard(
//                                   title: "Executive Summary",
//                                   icon: Icons.dashboard_outlined,
//                                   message:
//                                       "Step 10.3.4.3 will be inserted here.",
//                                 ),

//                                 const SizedBox(height: 20),

//                                 //--------------------------------
//                                 // Charts
//                                 //--------------------------------

//                                 _placeholderCard(
//                                   title: "Charts",
//                                   icon: Icons.bar_chart,
//                                   message:
//                                       "Step 10.3.4.6 will be inserted here.",
//                                 ),

//                                 const SizedBox(height: 20),

//                                 //--------------------------------
//                                 // Data Table
//                                 //--------------------------------

//                                 _placeholderCard(
//                                   title: "Report Data",
//                                   icon: Icons.table_rows_outlined,
//                                   message:
//                                       "Step 10.3.4.4 will be inserted here.",
//                                 ),
//                               ],
//                             ),
//                           ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   //---------------------------------------------------------
//   // Toolbar
//   //---------------------------------------------------------

//   Widget _buildToolbar(ReportProvider provider) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 12,
//       ),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xffE5E7EB),
//           ),
//         ),
//       ),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 12,
//         children: [

//           FilledButton.icon(
//             onPressed: provider.loading
//                 ? null
//                 : provider.loadReport,
//             icon: const Icon(Icons.analytics_outlined),
//             label: const Text("Generate Report"),
//           ),

//           OutlinedButton.icon(
//             onPressed: provider.loading
//                 ? null
//                 : provider.refresh,
//             icon: const Icon(Icons.refresh),
//             label: const Text("Refresh"),
//           ),

//           OutlinedButton.icon(
//             onPressed: provider.loading
//                 ? null
//                 : provider.exportPdf,
//             icon: const Icon(Icons.picture_as_pdf),
//             label: const Text("Export PDF"),
//           ),

//           OutlinedButton.icon(
//             onPressed: provider.loading
//                 ? null
//                 : provider.printReport,
//             icon: const Icon(Icons.print),
//             label: const Text("Print"),
//           ),
//         ],
//       ),
//     );
//   }

//   //---------------------------------------------------------
//   // Error
//   //---------------------------------------------------------

//   Widget _buildError(ReportProvider provider) {
//     return Center(
//       child: Card(
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [

//               const Icon(
//                 Icons.error_outline,
//                 color: Colors.red,
//                 size: 60,
//               ),

//               const SizedBox(height: 16),

//               const Text(
//                 "Unable to load report",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Text(
//                 provider.error ?? "",
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 20),

//               ElevatedButton.icon(
//                 onPressed: provider.refresh,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text("Try Again"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //---------------------------------------------------------
//   // Placeholder Sections
//   //---------------------------------------------------------

//   Widget _placeholderCard({
//     required String title,
//     required IconData icon,
//     required String message,
//   }) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: SizedBox(
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [

//               Icon(
//                 icon,
//                 size: 46,
//                 color: Colors.blue,
//               ),

//               const SizedBox(height: 12),

//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 message,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }