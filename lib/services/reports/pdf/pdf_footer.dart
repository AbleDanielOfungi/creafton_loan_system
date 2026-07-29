import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFooter {
  static pw.Widget build({
    required int pageNumber,
    required int totalPages,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 15),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColors.grey400,
            width: 0.6,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          //-----------------------------------------
          // LEFT
          //-----------------------------------------

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "CREAFTON FINANCIAL SERVICES",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                  color: PdfColors.blue900,
                ),
              ),

              pw.SizedBox(height: 2),

              pw.Text(
                "Confidential Internal Report",
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),

          //-----------------------------------------
          // CENTER
          //-----------------------------------------

          pw.Column(
            children: [
              pw.Text(
                "Generated:",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 8,
                ),
              ),

              pw.Text(
                DateFormat(
                  "dd MMM yyyy  hh:mm a",
                ).format(DateTime.now()),
                style: const pw.TextStyle(
                  fontSize: 8,
                ),
              ),
            ],
          ),

          //-----------------------------------------
          // RIGHT
          //-----------------------------------------

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                "Page $pageNumber of $totalPages",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                ),
              ),

              pw.SizedBox(height: 2),

               pw.Text(
                "Powered by CREAFTON ERP",
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}