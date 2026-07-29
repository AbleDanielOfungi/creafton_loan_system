import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

///==============================================================
/// CREAFTON FINANCIAL SERVICES
/// PDF REPORT HEADER
///==============================================================
class PdfHeader {
  static pw.Widget build({
    required String reportTitle,
    required DateTime generatedAt,
    DateTime? fromDate,
    DateTime? toDate, required String title,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),

      decoration: pw.BoxDecoration(
        color: PdfColors.blue900,

        borderRadius: pw.BorderRadius.circular(8),
      ),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          //--------------------------------------------------------
          // COMPANY NAME
          //--------------------------------------------------------

          pw.Text(
            "CREAFTON FINANCIAL SERVICES",
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            reportTitle,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 16,
            ),
          ),

          pw.SizedBox(height: 16),

          pw.Divider(color: PdfColors.white),

          pw.SizedBox(height: 8),

          //--------------------------------------------------------
          // REPORT INFORMATION
          //--------------------------------------------------------

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,

            children: [
              pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,

                children: [
                  _label(
                    "Generated",
                    DateFormat(
                      "dd MMM yyyy  hh:mm a",
                    ).format(generatedAt),
                  ),

                  if (fromDate != null)
                    _label(
                      "From",
                      DateFormat(
                        "dd MMM yyyy",
                      ).format(fromDate),
                    ),

                  if (toDate != null)
                    _label(
                      "To",
                      DateFormat(
                        "dd MMM yyyy",
                      ).format(toDate),
                    ),
                ],
              ),

              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),

                decoration: pw.BoxDecoration(
                  color: PdfColors.white,

                  borderRadius:
                      pw.BorderRadius.circular(20),
                ),

                child: pw.Text(
                  "CONFIDENTIAL",
                  style: pw.TextStyle(
                    color: PdfColors.red700,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------
  // LABEL
  //----------------------------------------------------------

  static pw.Widget _label(
    String title,
    String value,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),

      child: pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: "$title: ",

              style: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),

            pw.TextSpan(
              text: value,

              style: const pw.TextStyle(
                color: PdfColors.white,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}