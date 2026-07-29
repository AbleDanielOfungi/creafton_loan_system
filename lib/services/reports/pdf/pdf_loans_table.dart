// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// import '../../models/loan.dart';


// class PdfLoansTable {
//   static pw.Widget build(
//     List<Loan> loans,
//   ) {
//     if (loans.isEmpty) {
//       return pw.Container(
//         padding: const pw.EdgeInsets.all(10),
//         child: pw.Text(
//           "No loan records available",
//           style: pw.TextStyle(
//             fontSize: 10,
//           ),
//         ),
//       );
//     }

//     return pw.Table.fromTextArray(
//       headers: [
//         "Loan No.",
//         "Borrower",
//         "Amount (UGX)",
//         "Interest",
//         "Total Payable",
//         "Duration",
//         "Start Date",
//         "Status",
//       ],

//       data: loans.map((loan) {

//         return [
//           loan.loanNumber ?? "-",
//           loan.borrowerName ?? "-",

//           _formatCurrency(
//             loan.loanAmount,
//           ),

//           "${loan.interestRate}%",

//           _formatCurrency(
//             loan.totalPayable,
//           ),

//           "${loan.durationMonths} Months",

//           _formatDate(
//             loan.startDate,
//           ),

//           loan.status ?? "-",
//         ];

//       }).toList(),

//       border: pw.TableBorder.all(
//         color: PdfColors.grey400,
//       ),

//       headerStyle: pw.TextStyle(
//         fontSize: 9,
//         fontWeight: pw.FontWeight.bold,
//       ),

//       cellStyle: const pw.TextStyle(
//         fontSize: 8,
//       ),

//       headerDecoration: const pw.BoxDecoration(
//         color: PdfColors.grey300,
//       ),

//       cellAlignment:
//           pw.Alignment.centerLeft,

//       columnWidths: {

//         0: const pw.FlexColumnWidth(1.2),
//         1: const pw.FlexColumnWidth(2),
//         2: const pw.FlexColumnWidth(1.5),
//         3: const pw.FlexColumnWidth(1),
//         4: const pw.FlexColumnWidth(1.5),
//         5: const pw.FlexColumnWidth(1),
//         6: const pw.FlexColumnWidth(1.5),
//         7: const pw.FlexColumnWidth(1),

//       },
//     );
//   }


//   static String _formatCurrency(
//     double? amount,
//   ) {

//     if (amount == null) {
//       return "0";
//     }

//     return "UGX ${amount.toStringAsFixed(0)}";
//   }



//   static String _formatDate(
//     DateTime? date,
//   ) {

//     if (date == null) {
//       return "-";
//     }

//     return "${date.day.toString().padLeft(2,'0')}/"
//         "${date.month.toString().padLeft(2,'0')}/"
//         "${date.year}";
//   }

// }