// import 'package:creafton_financial_services/models/guarantor.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// // import '../../models/guarantor.dart';


// class PdfGuarantorsTable {


//   static pw.Widget build(
//     List<Guarantor> guarantors,
//   ) {


//     if (guarantors.isEmpty) {

//       return pw.Container(

//         padding: const pw.EdgeInsets.all(10),

//         child: pw.Text(

//           "No guarantor records available",

//           style: const pw.TextStyle(

//             fontSize: 10,

//           ),

//         ),

//       );

//     }



//     return pw.Table.fromTextArray(


//       headers: [

//         "ID",

//         "Guarantor",

//         "Borrower",

//         "Relationship",

//         "Phone",

//         "National ID",

//         "Address",

//         "Status",

//       ],




//       data: guarantors.map((guarantor) {


//         return [


//           guarantor.id?.toString() ?? "-",



//           guarantor.name ?? "-",



//           guarantor.borrowerName ?? "-",



//           guarantor.relationship ?? "-",



//           guarantor.phoneNumber ?? "-",



//           guarantor.nationalId ?? "-",



//           guarantor.address ?? "-",



//           guarantor.status ?? "-",


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


//         1: const pw.FlexColumnWidth(1.8),


//         2: const pw.FlexColumnWidth(1.8),


//         3: const pw.FlexColumnWidth(1.2),


//         4: const pw.FlexColumnWidth(1.2),


//         5: const pw.FlexColumnWidth(1.5),


//         6: const pw.FlexColumnWidth(2),


//         7: const pw.FlexColumnWidth(1),


//       },


//     );


//   }



// }