// import 'package:creafton_financial_services/models/field_officer.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;




// class PdfFieldOfficersTable {


//   static pw.Widget build(
//     List<FieldOfficer> officers,
//   ) {


//     if (officers.isEmpty) {

//       return pw.Container(

//         padding: const pw.EdgeInsets.all(10),

//         child: pw.Text(

//           "No field officer records available",

//           style: const pw.TextStyle(

//             fontSize: 10,

//           ),

//         ),

//       );

//     }



//     return pw.Table.fromTextArray(


//       headers: [

//         "Officer",

//         "Phone",

//         "Borrowers",

//         "Active Loans",

//         "Loan Portfolio",

//         "Collections",

//         "Outstanding",

//         "Collection Rate",

//         "Status",

//       ],



//       data: officers.map((officer) {


//         return [


//           officer.fullName ?? "-",


//           officer.phoneNumber ?? "-",


//           officer.assignedBorrowers
//                   ?.toString() ??
//               "0",



//           officer.activeLoans
//                   ?.toString() ??
//               "0",



//           _formatCurrency(

//             officer.totalLoanAmount,

//           ),



//           _formatCurrency(

//             officer.totalCollections,

//           ),



//           _formatCurrency(

//             officer.outstandingBalance,

//           ),



//           "${officer.collectionRate ?? 0}%",



//           officer.performanceStatus ?? "-",


//         ];


//       }).toList(),




//       border: pw.TableBorder.all(

//         color: PdfColors.grey400,

//       ),




//       headerStyle: pw.TextStyle(

//         fontSize: 8,

//         fontWeight: pw.FontWeight.bold,

//       ),




//       cellStyle: const pw.TextStyle(

//         fontSize: 7,

//       ),




//       headerDecoration:
//           const pw.BoxDecoration(

//         color: PdfColors.grey300,

//       ),




//       cellAlignment:
//           pw.Alignment.centerLeft,




//       columnWidths: {


//         0: const pw.FlexColumnWidth(1.8),

//         1: const pw.FlexColumnWidth(1.3),

//         2: const pw.FlexColumnWidth(0.9),

//         3: const pw.FlexColumnWidth(0.9),

//         4: const pw.FlexColumnWidth(1.5),

//         5: const pw.FlexColumnWidth(1.5),

//         6: const pw.FlexColumnWidth(1.5),

//         7: const pw.FlexColumnWidth(1),

//         8: const pw.FlexColumnWidth(1.2),


//       },


//     );

//   }





//   static String _formatCurrency(

//     double? amount,

//   ) {


//     if (amount == null) {

//       return "UGX 0";

//     }



//     return "UGX ${amount.toStringAsFixed(0)}";

//   }


// }