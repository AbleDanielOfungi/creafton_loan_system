// import 'package:creafton_financial_services/providers/reports_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';



// class ReportFilterPanel extends StatelessWidget {
//   const ReportFilterPanel({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ReportProvider>(
//       builder: (context, provider, child) {
//         return Card(
//           elevation: 1,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Row(
//                   children: [
//                     Icon(Icons.filter_alt_outlined),
//                     SizedBox(width: 8),
//                     Text(
//                       "Report Filters",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 Wrap(
//                   spacing: 20,
//                   runSpacing: 20,
//                   children: [
//                     SizedBox(
//                       width: 260,
//                       child: DropdownButtonFormField<ReportType>(
//                         value: provider.reportType,
//                         decoration: const InputDecoration(
//                           labelText: "Report Type",
//                           border: OutlineInputBorder(),
//                         ),
//                         items: ReportType.values.map((type) {
//                           return DropdownMenuItem(
//                             value: type,
//                             child: Text(_reportTypeName(type)),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             provider.setReportType(value);
//                           }
//                         },
//                       ),
//                     ),

//                     SizedBox(
//                       width: 200,
//                       child: _DateSelector(
//                         label: "Start Date",
//                         date: provider.startDate,
//                         onSelected: (date) {
//                           provider.setDateRange(
//                             date,
//                             provider.endDate,
//                           );
//                         },
//                       ),
//                     ),

//                     SizedBox(
//                       width: 200,
//                       child: _DateSelector(
//                         label: "End Date",
//                         date: provider.endDate,
//                         onSelected: (date) {
//                           provider.setDateRange(
//                             provider.startDate,
//                             date,
//                           );
//                         },
//                       ),
//                     ),

//                     SizedBox(
//                       width: 220,
//                       child: DropdownButtonFormField<String>(
//                         value: provider.loanStatus,
//                         decoration: const InputDecoration(
//                           labelText: "Loan Status",
//                           border: OutlineInputBorder(),
//                         ),
//                         items: const [
//                           DropdownMenuItem(
//                             value: null,
//                             child: Text("All Statuses"),
//                           ),
//                           DropdownMenuItem(
//                             value: "ACTIVE",
//                             child: Text("Active"),
//                           ),
//                           DropdownMenuItem(
//                             value: "COMPLETED",
//                             child: Text("Completed"),
//                           ),
//                           DropdownMenuItem(
//                             value: "PENDING",
//                             child: Text("Pending"),
//                           ),
//                           DropdownMenuItem(
//                             value: "DEFAULTED",
//                             child: Text("Defaulted"),
//                           ),
//                         ],
//                         onChanged: provider.setLoanStatus,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 25),

//                 Row(
//                   children: [
//                     FilledButton.icon(
//                       onPressed: provider.loadReport,
//                       icon: const Icon(Icons.analytics),
//                       label: const Text("Generate Report"),
//                     ),

//                     const SizedBox(width: 12),

//                     OutlinedButton.icon(
//                       onPressed: () {
//                         provider.clearFilters();
//                         provider.loadReport();
//                       },
//                       icon: const Icon(Icons.clear),
//                       label: const Text("Reset Filters"),
//                     ),

//                     const Spacer(),

//                     Text(
//                       provider.lastLoaded == null
//                           ? "Not generated"
//                           : "Last generated: ${provider.lastLoaded}",
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   static String _reportTypeName(ReportType type) {
//     switch (type) {
//       case ReportType.executive:
//         return "Executive Summary";

//       case ReportType.borrowers:
//         return "Borrowers";

//       case ReportType.loans:
//         return "Loans";

//       case ReportType.payments:
//         return "Payments";

//       case ReportType.arrears:
//         return "Loan Arrears";

//       case ReportType.fieldOfficers:
//         return "Field Officers";

//       case ReportType.expenses:
//         return "Expenses";

//       case ReportType.guarantors:
//         return "Guarantors";
//     }
//   }
// }

// class _DateSelector extends StatelessWidget {
//   final String label;
//   final DateTime? date;
//   final ValueChanged<DateTime?> onSelected;

//   const _DateSelector({
//     required this.label,
//     required this.date,
//     required this.onSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       readOnly: true,
//       decoration: InputDecoration(
//         border: const OutlineInputBorder(),
//         labelText: label,
//         suffixIcon: const Icon(Icons.calendar_today),
//         hintText: date == null
//             ? "Select Date"
//             : "${date!.day}/${date!.month}/${date!.year}",
//       ),
//       onTap: () async {
//         final selected = await showDatePicker(
//           context: context,
//           initialDate: date ?? DateTime.now(),
//           firstDate: DateTime(2020),
//           lastDate: DateTime(2100),
//         );

//         if (selected != null) {
//           onSelected(selected);
//         }
//       },
//     );
//   }
// }