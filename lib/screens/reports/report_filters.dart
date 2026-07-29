// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/borrower_provider.dart';
// import '../../../providers/field_officer_provider.dart';
// import '../../../providers/reports_provider.dart';

// class ReportFilters extends StatefulWidget {
//   const ReportFilters({super.key});

//   @override
//   State<ReportFilters> createState() => _ReportFiltersState();
// }

// class _ReportFiltersState extends State<ReportFilters> {
//   DateTime? fromDate;
//   DateTime? toDate;
//   int? borrowerId;
//   int? officerId;
//   String loanStatus = "ALL";
//   String paymentStatus = "ALL";
//   String reportCategory = "ALL";

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BorrowerProvider>().loadBorrowers();
//       context.read<FieldOfficerProvider>().loadOfficers();
//     });
//   }

//   Future<void> pickFromDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: fromDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         fromDate = picked;
//       });
//     }
//   }

//   Future<void> pickToDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: toDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         toDate = picked;
//       });
//     }
//   }

//   void generateReport() {
//     if (fromDate == null || toDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select both From and To dates.")),
//       );

//       return;
//     }
//     print(
//       "calling provider to generate report with filters: fromDate=$fromDate, toDate=$toDate, borrowerId=$borrowerId, officerId=$officerId, loanStatus=$loanStatus, paymentStatus=$paymentStatus, reportCategory=$reportCategory",
//     );
//     context.read<ReportsProvider>().generateCustomReport(
//       from: fromDate!,
//       to: toDate!,
//     );
//   }

//   void clearFilters() {
//     setState(() {
//       fromDate = null;
//       toDate = null;
//       borrowerId = null;
//       officerId = null;

//       loanStatus = "ALL";
//       paymentStatus = "ALL";
//       reportCategory = "ALL";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final borrowers = context.watch<BorrowerProvider>().borrowers;
//     final officers = context.watch<FieldOfficerProvider>().officers;
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Wrap(
//           spacing: 20,
//           runSpacing: 20,
//           crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             SizedBox(
//               width: 180,
//               child: OutlinedButton.icon(
//                 icon: const Icon(Icons.calendar_today),
//                 label: Text(
//                   fromDate == null
//                       ? "From Date"
//                       : DateFormat("dd MMM yyyy").format(fromDate!),
//                 ),
//                 onPressed: pickFromDate,
//               ),
//             ),
//             SizedBox(
//               width: 180,
//               child: OutlinedButton.icon(
//                 icon: const Icon(Icons.calendar_month),
//                 label: Text(
//                   toDate == null
//                       ? "To Date"
//                       : DateFormat("dd MMM yyyy").format(toDate!),
//                 ),
//                 onPressed: pickToDate,
//               ),
//             ),
//             SizedBox(
//               width: 250,
//               child: DropdownButtonFormField<int?>(
//                 value: borrowerId,
//                 decoration: const InputDecoration(
//                   labelText: "Borrower",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   const DropdownMenuItem(
//                     value: null,
//                     child: Text("All Borrowers"),
//                   ),
//                   ...borrowers.map(
//                     (b) =>
//                         DropdownMenuItem(value: b.id, child: Text(b.fullName)),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     borrowerId = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               width: 250,
//               child: DropdownButtonFormField<int?>(
//                 value: officerId,
//                 decoration: const InputDecoration(
//                   labelText: "Field Officer",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   const DropdownMenuItem(
//                     value: null,
//                     child: Text("All Field Officers"),
//                   ),
//                   ...officers.map(
//                     (o) =>
//                         DropdownMenuItem(value: o.id, child: Text(o.fullName)),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     officerId = value;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               width: 170,
//               child: DropdownButtonFormField<String>(
//                 value: loanStatus,
//                 decoration: const InputDecoration(
//                   labelText: "Loan Status",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: "ALL", child: Text("All")),
//                   DropdownMenuItem(value: "ACTIVE", child: Text("Active")),
//                   DropdownMenuItem(
//                     value: "COMPLETED",
//                     child: Text("Completed"),
//                   ),
//                   DropdownMenuItem(
//                     value: "DEFAULTED",
//                     child: Text("Defaulted"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     loanStatus = value!;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               width: 180,
//               child: DropdownButtonFormField<String>(
//                 value: paymentStatus,
//                 decoration: const InputDecoration(
//                   labelText: "Payment Status",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(value: "ALL", child: Text("All")),
//                   DropdownMenuItem(value: "PAID", child: Text("Paid")),
//                   DropdownMenuItem(value: "PENDING", child: Text("Pending")),
//                   DropdownMenuItem(value: "OVERDUE", child: Text("Overdue")),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     paymentStatus = value!;
//                   });
//                 },
//               ),
//             ),
//             SizedBox(
//               width: 220,
//               child: DropdownButtonFormField<String>(
//                 value: reportCategory,
//                 decoration: const InputDecoration(
//                   labelText: "Report Category",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: const [
//                   DropdownMenuItem(
//                     value: "ALL",
//                     child: Text("Complete Report"),
//                   ),
//                   DropdownMenuItem(
//                     value: "BORROWERS",
//                     child: Text("Borrowers"),
//                   ),
//                   DropdownMenuItem(value: "LOANS", child: Text("Loans")),
//                   DropdownMenuItem(value: "PAYMENTS", child: Text("Payments")),
//                   DropdownMenuItem(
//                     value: "FIELD_OFFICERS",
//                     child: Text("Field Officers"),
//                   ),
//                   DropdownMenuItem(
//                     value: "DEFAULTERS",
//                     child: Text("Defaulters"),
//                   ),
//                   DropdownMenuItem(
//                     value: "EXPENDITURES",
//                     child: Text("Expenditures"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     reportCategory = value!;
//                   });
//                 },
//               ),
//             ),
//             FilledButton.icon(
//               icon: const Icon(Icons.analytics),
//               label: const Text("Generate Report"),
//               onPressed: generateReport,
//             ),

//             OutlinedButton.icon(
//               icon: const Icon(Icons.clear),
//               label: const Text("Clear Filters"),
//               onPressed: clearFilters,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
