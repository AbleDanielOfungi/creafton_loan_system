// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/reports_provider.dart';

// class ReportHeader extends StatelessWidget {
//   const ReportHeader({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ReportsProvider>(
//       builder: (context, provider, child) {
//         return Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //----------------------------------------------------
//                 // LEFT
//                 //----------------------------------------------------

//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "CREAFTON FINANCIAL SERVICES",
//                         style: TextStyle(
//                           fontSize: 26,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff0D47A1),
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       Text(
//                         "Management Reporting Dashboard",
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             size: 18,
//                           ),

//                           const SizedBox(width: 10),

//                           Text(
//                             DateFormat(
//                               "EEEE, dd MMMM yyyy",
//                             ).format(DateTime.now()),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),

//                           const SizedBox(width: 25),

//                           const Icon(
//                             Icons.access_time,
//                             size: 18,
//                           ),

//                           const SizedBox(width: 10),

//                           Text(
//                             DateFormat(
//                               "hh:mm a",
//                             ).format(DateTime.now()),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 //----------------------------------------------------
//                 // RIGHT
//                 //----------------------------------------------------

//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.end,
//                     children: [
//                       SizedBox(
//                         width: 240,
//                         child: DropdownButtonFormField<String>(
//                           value: provider.selectedReport,

//                           decoration: InputDecoration(
//                             labelText: "Report Type",

//                             filled: true,

//                             fillColor:
//                                 Colors.grey.shade100,

//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.circular(12),
//                             ),
//                           ),

//                           items: const [
//                             DropdownMenuItem(
//                               value: "Daily",
//                               child: Text("Daily Report"),
//                             ),
//                             DropdownMenuItem(
//                               value: "Weekly",
//                               child: Text("Weekly Report"),
//                             ),
//                             DropdownMenuItem(
//                               value: "Monthly",
//                               child: Text("Monthly Report"),
//                             ),
//                             DropdownMenuItem(
//                               value: "Yearly",
//                               child: Text("Yearly Report"),
//                             ),
//                             DropdownMenuItem(
//                               value: "Custom",
//                               child: Text("Custom Report"),
//                             ),
//                           ],

//                           onChanged: (value) {
//                             if (value != null) {
//                               provider.changeReport(value);
//                             }
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       Wrap(
//                         spacing: 12,
//                         runSpacing: 12,
//                         alignment: WrapAlignment.end,
//                         children: [
//                           FilledButton.icon(
//                             icon: const Icon(Icons.refresh),

//                             label: const Text("Refresh"),

//                             onPressed: () {
//                               provider.loadDashboard();
//                             },
//                           ),

//                           FilledButton.icon(
//                             icon: const Icon(
//                                 Icons.picture_as_pdf),

//                             label: const Text("PDF"),

//                             style:
//                                 FilledButton.styleFrom(
//                               backgroundColor:
//                                   Colors.red,
//                             ),

//                             onPressed: () {
//                               provider.exportPdf();
//                             },
//                           ),

//                           FilledButton.icon(
//                             icon: const Icon(
//                                 Icons.table_chart),

//                             label: const Text("Excel"),

//                             style:
//                                 FilledButton.styleFrom(
//                               backgroundColor:
//                                   Colors.green,
//                             ),

//                             onPressed: () {
//                               provider.exportExcel();
//                             },
//                           ),

//                           FilledButton.icon(
//                             icon:
//                                 const Icon(Icons.print),

//                             label:
//                                 const Text("Print"),

//                             style:
//                                 FilledButton.styleFrom(
//                               backgroundColor:
//                                   Colors.orange,
//                             ),

//                             onPressed: () {
//                               provider.printReport();
//                             },
//                           ),

//                           FilledButton.icon(
//                             icon: const Icon(
//                               Icons.analytics,
//                             ),

//                             label: const Text(
//                               "Generate",
//                             ),

//                             style:
//                                 FilledButton.styleFrom(
//                               backgroundColor:
//                                   Colors.indigo,
//                             ),

//                             onPressed: () {
//                               provider.generateSelectedReport();
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }