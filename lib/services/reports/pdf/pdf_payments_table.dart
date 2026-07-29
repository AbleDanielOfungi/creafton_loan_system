// import 'package:creafton_financial_services/models/payment.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;



// class PdfPaymentsTable {
//   static pw.Widget build(
//     List<Payment> payments,
//   ) {

//     if (payments.isEmpty) {
//       return pw.Container(
//         padding: const pw.EdgeInsets.all(10),
//         child: pw.Text(
//           "No payment records available",
//           style: const pw.TextStyle(
//             fontSize: 10,
//           ),
//         ),
//       );
//     }


//     return pw.Table.fromTextArray(

//       headers: [

//         "Payment ID",
//         "Borrower",
//         "Loan No.",
//         "Amount Paid",
//         "Payment Date",
//         "Method",
//         "Collected By",

//       ],


//       data: payments.map((payment) {


//         return [

//           payment.id?.toString() ?? "-",

//           payment.borrowerName ?? "-",

//           payment.loanNumber ?? "-",

//           _formatCurrency(
//             payment.amount,
//           ),


//           _formatDate(
//             payment!.paymentDate,
//           ),


//           payment.paymentMethod ?? "-",


//           payment.collectedBy ?? "-",


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



//       headerDecoration:
//           const pw.BoxDecoration(

//         color: PdfColors.grey300,

//       ),



//       cellAlignment:
//           pw.Alignment.centerLeft,



//       columnWidths: {


//         0: const pw.FlexColumnWidth(1),

//         1: const pw.FlexColumnWidth(2),

//         2: const pw.FlexColumnWidth(1.3),

//         3: const pw.FlexColumnWidth(1.5),

//         4: const pw.FlexColumnWidth(1.5),

//         5: const pw.FlexColumnWidth(1.2),

//         6: const pw.FlexColumnWidth(1.5),


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






//   static String _formatDate(

//     DateTime? date,

//   ) {


//     if (date == null) {

//       return "-";

//     }



//     return "${date.day.toString().padLeft(2, '0')}/"

//         "${date.month.toString().padLeft(2, '0')}/"

//         "${date.year}";

//   }

// }