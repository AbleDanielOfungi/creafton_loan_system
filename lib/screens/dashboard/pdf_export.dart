import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'dashboard_repository.dart';

/// Builds and opens a print/save-as-PDF dialog for the list of borrowers
/// who haven't paid their loan installment for today.
///
/// Uses the `printing` package's [Printing.layoutPdf], which on desktop
/// (Windows/macOS/Linux) opens the native print dialog with a "Save as PDF"
/// / "Print to file" option — no extra file-path/permission handling needed.
class PdfExport {
  static Future<void> exportTodayDefaulters({
    required List<TodayDefaulter> defaulters,
    required String businessName,
    required String currency,
  }) async {
    final money = NumberFormat.currency(
      locale: 'en_US',
      symbol: '$currency ',
      decimalDigits: 0,
    );
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    final doc = pw.Document();

    final totalDue = defaulters.fold<double>(0, (sum, d) => sum + d.amountDue);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              businessName,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Borrowers Who Have Not Paid Today · $today',
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(),
          ],
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total unpaid today: ${defaulters.length} borrower(s)',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text('Total amount due: ${money.format(totalDue)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(0.4),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1.5),
              3: pw.FlexColumnWidth(1.3),
              4: pw.FlexColumnWidth(1.3),
              5: pw.FlexColumnWidth(1.3),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _cell('#', bold: true),
                  _cell('Borrower', bold: true),
                  _cell('Phone', bold: true),
                  _cell('District', bold: true),
                  _cell('Loan No.', bold: true),
                  _cell('Amount Due', bold: true),
                ],
              ),
              for (var i = 0; i < defaulters.length; i++)
                pw.TableRow(
                  children: [
                    _cell('${i + 1}'),
                    _cell(defaulters[i].borrowerName),
                    _cell(defaulters[i].phone),
                    _cell(defaulters[i].district ?? '—'),
                    _cell(defaulters[i].loanNumber),
                    _cell(money.format(defaulters[i].amountDue)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name: 'unpaid_today_${DateFormat('yyyy_MM_dd').format(DateTime.now())}.pdf',
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      );
}