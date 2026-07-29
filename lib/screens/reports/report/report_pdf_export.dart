import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'report_models.dart';

/// Builds a PDF report for the currently selected period/filter.
///
/// Pass in exactly the same data the screen has already loaded so the
/// PDF always matches what's on screen.
class ReportPdfExporter {
  static Future<Uint8List> build({
    required String rangeLabel,
    required ReportSummary summary,
    required List<Map<String, Object?>> loans,
    required List<Map<String, Object?>> payments,
    required List<Map<String, Object?>> borrowers,
    required List<Map<String, Object?>> expenditures,
    required List<FieldOfficerSummary> officers,
  }) async {
    final doc = pw.Document();

    final headerStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );
    final labelStyle = pw.TextStyle(
      fontSize: 9,
      color: PdfColors.grey700,
      fontWeight: pw.FontWeight.normal,
    );
    final valueStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
    );

    // ---- Page 1: Summary -------------------------------------------------
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => _pageHeader(rangeLabel, headerStyle),
        footer: (context) => _pageFooter(context),
        build: (context) => [
          pw.SizedBox(height: 12),
          _summaryGrid(labelStyle, valueStyle, [
            ('New Borrowers', '${summary.newBorrowers}'),
            ('New Loans', '${summary.newLoans}'),
            ('Disbursed', _money(summary.totalDisbursed)),
            ('Collected', _money(summary.totalCollected)),
            ('Expenditure', _money(summary.totalExpenditure)),
            ('Net Cash Flow', _money(summary.netCashFlow)),
            ('Active Loans (all time)', '${summary.activeLoansAllTime}'),
            (
              'Outstanding (all time)',
              _money(summary.outstandingBalanceAllTime),
            ),
          ]),
          pw.SizedBox(height: 20),
          if (loans.isNotEmpty) ...[
            _sectionTitle('Loans (${loans.length})'),
            _table(
              headers: const [
                'Loan #',
                'Borrower',
                'Officer',
                'Principal',
                'Payable',
                'Balance',
                'Status',
                'Start',
              ],
              rows: loans
                  .map(
                    (l) => [
                      '${l['loan_number']}',
                      '${l['borrower_name']}',
                      '${l['officer_name'] ?? '—'}',
                      _money(l['principal_amount']),
                      _money(l['total_payable']),
                      _money(l['remaining_balance']),
                      '${l['status']}',
                      _shortDate(l['start_date']),
                    ],
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 16),
          ],
          if (payments.isNotEmpty) ...[
            _sectionTitle('Payments (${payments.length})'),
            _table(
              headers: const [
                'Loan #',
                'Borrower',
                'Officer',
                'Amount',
                'Type',
                'Status',
                'Date',
              ],
              rows: payments
                  .map(
                    (p) => [
                      '${p['loan_number']}',
                      '${p['borrower_name']}',
                      '${p['officer_name'] ?? '—'}',
                      _money(p['amount']),
                      '${p['payment_type'] ?? '—'}',
                      '${p['status']}',
                      _shortDate(p['payment_date']),
                    ],
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 16),
          ],
          if (borrowers.isNotEmpty) ...[
            _sectionTitle('Borrowers (${borrowers.length})'),
            _table(
              headers: const [
                'Borrower #',
                'Name',
                'Phone',
                'District',
                'Officer',
                'Loans',
                'Guarantors',
                'Status',
              ],
              rows: borrowers
                  .map(
                    (b) => [
                      '${b['borrower_number']}',
                      '${b['full_name']}',
                      '${b['phone']}',
                      '${b['district'] ?? '—'}',
                      '${b['officer_name'] ?? '—'}',
                      '${b['loan_count']}',
                      '${b['guarantor_count']}',
                      '${b['status']}',
                    ],
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 16),
          ],
          if (officers.isNotEmpty) ...[
            _sectionTitle('Field Officers (${officers.length})'),
            _table(
              headers: const [
                'Officer #',
                'Name',
                'Loans Issued',
                'Disbursed',
                'Collected',
              ],
              rows: officers
                  .map(
                    (o) => [
                      o.officerNumber,
                      o.name,
                      '${o.loanCount}',
                      _money(o.disbursed),
                      _money(o.collected),
                    ],
                  )
                  .toList(),
            ),
            pw.SizedBox(height: 16),
          ],
          if (expenditures.isNotEmpty) ...[
            _sectionTitle('Expenditures (${expenditures.length})'),
            _table(
              headers: const ['Category', 'Title', 'Amount', 'Method', 'Date'],
              rows: expenditures
                  .map(
                    (e) => [
                      '${e['category_name']}',
                      '${e['title']}',
                      _money(e['amount']),
                      '${e['payment_method'] ?? '—'}',
                      _shortDate(e['expense_date']),
                    ],
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _pageHeader(String rangeLabel, pw.TextStyle headerStyle) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Creafton Financial Service Report', style: headerStyle),
        pw.SizedBox(height: 2),
        pw.Text(
          rangeLabel,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 6),
        pw.Divider(color: PdfColors.grey400),
      ],
    );
  }

  static pw.Widget _pageFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated ${DateTime.now().toIso8601String().split('T').first}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the summary cards as a fixed 2-column pw.Table.
  ///
  /// Deliberately NOT using pw.GridView here — its page-fitting logic is
  /// unreliable in the `pdf` package and can throw PdfTooBigException even
  /// with a handful of items. pw.Table paginates correctly.
  static pw.Widget _summaryGrid(
    pw.TextStyle labelStyle,
    pw.TextStyle valueStyle,
    List<(String, String)> items,
  ) {
    final rows = <pw.TableRow>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        pw.TableRow(
          children: [
            _summaryTile(left.$1, left.$2, labelStyle, valueStyle),
            right != null
                ? _summaryTile(right.$1, right.$2, labelStyle, valueStyle)
                : pw.SizedBox(),
          ],
        ),
      );
    }
    return pw.Table(
      columnWidths: const {0: pw.FlexColumnWidth(), 1: pw.FlexColumnWidth()},
      children: rows,
    );
  }

  static pw.Widget _summaryTile(
    String label,
    String value,
    pw.TextStyle labelStyle,
    pw.TextStyle valueStyle,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(4),
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(label, style: labelStyle),
          pw.SizedBox(height: 2),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }

  static pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _table({
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerStyle: pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellHeight: 20,
      cellAlignment: pw.Alignment.centerLeft,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      rowDecoration: const pw.BoxDecoration(color: PdfColors.white),
    );
  }

  static String _money(Object? value) {
    final n = (value is num) ? value : num.tryParse('$value') ?? 0;
    final isNegative = n < 0;
    final fixed = n.abs().toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < fixed.length; i++) {
      final posFromEnd = fixed.length - i;
      buffer.write(fixed[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write(',');
    }
    return '${isNegative ? '-' : ''}UGX ${buffer.toString()}';
  }

  static String _shortDate(Object? value) {
    if (value == null) return '—';
    final parsed = DateTime.tryParse('$value');
    if (parsed == null) return '$value';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${parsed.year}-${two(parsed.month)}-${two(parsed.day)}';
  }
}
