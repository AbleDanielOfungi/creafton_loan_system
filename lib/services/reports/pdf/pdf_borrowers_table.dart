// import 'package:creafton_financial_services/models/reports/borrower_report.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;



// class PdfBorrowersTable {
//   static pw.Widget build(
//     List<BorrowerReport> borrowers,
//   ) {
//     if (borrowers.isEmpty) {
//       return pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Header(
//             level: 1,
//             child: pw.Text("Borrowers"),
//           ),
//           pw.Container(
//             padding: const pw.EdgeInsets.all(15),
//             alignment: pw.Alignment.center,
//             child: pw.Text(
//               "No borrower records found.",
//               style: const pw.TextStyle(
//                 color: PdfColors.grey700,
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return pw.Column(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Header(
//           level: 1,
//           child: pw.Text(
//             "Borrowers (${borrowers.length})",
//           ),
//         ),

//         pw.TableHelper.fromTextArray(
//           border: pw.TableBorder.all(
//             color: PdfColors.grey400,
//           ),

//           headerDecoration: const pw.BoxDecoration(
//             color: PdfColors.blue900,
//           ),

//           headerStyle: pw.TextStyle(
//             color: PdfColors.white,
//             fontWeight: pw.FontWeight.bold,
//             fontSize: 10,
//           ),

//           cellStyle: const pw.TextStyle(
//             fontSize: 9,
//           ),

//           cellAlignment:
//               pw.Alignment.centerLeft,

//           columnWidths: {
//             0: const pw.FixedColumnWidth(28),
//             1: const pw.FlexColumnWidth(3),
//             2: const pw.FlexColumnWidth(2),
//             3: const pw.FlexColumnWidth(2),
//             4: const pw.FlexColumnWidth(2),
//             5: const pw.FlexColumnWidth(2),
//             6: const pw.FlexColumnWidth(1.5),
//           },

//           headers: const [
//             "#",
//             "Borrower",
//             "Phone",
//             "Field Officer",
//             "Loan No.",
//             "Balance",
//             "Status",
//           ],

//           data: List.generate(
//             borrowers.length,
//             (index) {
//               final b = borrowers[index];

//               return [
//                 "${index + 1}",
//                 b.fullName,
//                 b.phone,
//                 b.fieldOfficer ?? "-",
//                 b.loanNumber ?? "-",
//                 "UGX ${b.remainingBalance.toStringAsFixed(0)}",
//                 b.status,
//               ];
//             },
//           ),

//           rowDecoration: const pw.BoxDecoration(),

//           oddRowDecoration: const pw.BoxDecoration(
//             color: PdfColors.grey100,
//           ),
//         ),
//       ],
//     );
//   }
// }