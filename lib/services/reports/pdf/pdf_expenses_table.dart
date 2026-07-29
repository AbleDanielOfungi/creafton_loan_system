// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;



// class PdfExpensesTable {


//   static pw.Widget build(
//     List<Expenditure> expenses,
//   ) {


//     if (expenses.isEmpty) {

//       return pw.Container(

//         padding: const pw.EdgeInsets.all(10),

//         child: pw.Text(

//           "No expense records available",

//           style: const pw.TextStyle(

//             fontSize: 10,

//           ),

//         ),

//       );

//     }



//     return pw.Table.fromTextArray(

//       headers: [


//         "ID",

//         "Date",

//         "Category",

//         "Description",

//         "Amount (UGX)",

//         "Payment Method",

//         "Recorded By",

//         "Status",

//       ],




//       data: expenses.map((expense) {


//         return [


//           expense.id?.toString() ?? "-",



//           _formatDate(

//             expense.expenseDate,

//           ),



//           expense.categoryName ?? "-",



//           expense.description ?? "-",



//           _formatCurrency(

//             expense.amount,

//           ),



//           expense.paymentMethod ?? "-",



//           expense.recordedBy ?? "-",



//           expense.status ?? "-",


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



//         0: const pw.FlexColumnWidth(0.6),

//         1: const pw.FlexColumnWidth(1.2),

//         2: const pw.FlexColumnWidth(1.4),

//         3: const pw.FlexColumnWidth(2.2),

//         4: const pw.FlexColumnWidth(1.4),

//         5: const pw.FlexColumnWidth(1.3),

//         6: const pw.FlexColumnWidth(1.4),

//         7: const pw.FlexColumnWidth(1),


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