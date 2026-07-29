import 'package:creafton_financial_services/screens/reports/report/report_pdf_export.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import 'report_models.dart';
import 'report_repository.dart';

/// A professional financial reports screen for desktop.
///
/// Filters by Day / Week / Month / Year (navigate with the arrows or jump
/// back to "Today"), and surfaces borrowers, loans, payments, field
/// officers, and expenditures for the selected period — using the joins
/// already modeled in DatabaseHelper's schema.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  final ReportRepository _repo = ReportRepository();

  ReportPeriod _period = ReportPeriod.month;
  DateTime _anchor = DateTime.now();
  late TabController _tabController;
  bool _exporting = false;

  bool _loading = true;
  String? _error;

  ReportSummary? _summary;
  List<Map<String, Object?>> _loans = [];
  List<Map<String, Object?>> _payments = [];
  List<Map<String, Object?>> _borrowers = [];
  List<Map<String, Object?>> _expenditures = [];
  List<FieldOfficerSummary> _officers = [];

  DateRange get _range => DateRange.forPeriod(_period, _anchor);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final range = _range;
      final results = await Future.wait([
        _repo.getSummary(range),
        _repo.getLoans(range),
        _repo.getPayments(range),
        _repo.getBorrowers(range),
        _repo.getExpenditures(range),
        _repo.getFieldOfficerSummaries(range),
      ]);
      setState(() {
        _summary = results[0] as ReportSummary;
        _loans = results[1] as List<Map<String, Object?>>;
        _payments = results[2] as List<Map<String, Object?>>;
        _borrowers = results[3] as List<Map<String, Object?>>;
        _expenditures = results[4] as List<Map<String, Object?>>;
        _officers = results[5] as List<FieldOfficerSummary>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load report: $e';
        _loading = false;
      });
    }
  }

  void _shift(int direction) {
    setState(() {
      switch (_period) {
        case ReportPeriod.day:
          _anchor = _anchor.add(Duration(days: direction));
          break;
        case ReportPeriod.week:
          _anchor = _anchor.add(Duration(days: 7 * direction));
          break;
        case ReportPeriod.month:
          _anchor = DateTime(_anchor.year, _anchor.month + direction, 1);
          break;
        case ReportPeriod.year:
          _anchor = DateTime(_anchor.year + direction, _anchor.month, 1);
          break;
        case ReportPeriod.custom:
          break;
      }
    });
    _load();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _anchor,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _anchor = picked);
      _load();
    }
  }

  Future<void> _exportPdf() async {
    if (_summary == null) return;
    setState(() => _exporting = true);
    try {
      final bytes = await ReportPdfExporter.build(
        rangeLabel: _range.label,
        summary: _summary!,
        loans: _loans,
        payments: _payments,
        borrowers: _borrowers,
        expenditures: _expenditures,
        officers: _officers,
      );
      final fileName =
          'financial_report_${_range.label.replaceAll(RegExp(r'[^\w-]+'), '_')}.pdf';

      // Opens the OS save/print dialog on desktop, and downloads on web.
      await Printing.sharePdf(bytes: bytes, filename: fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to export PDF: $e')));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (_summary != null) _buildSummaryCards(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildTabs(),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // HEADER: title + period selector + navigation
  // -----------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E3E7))),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 12,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Financial Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                _range.label,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<ReportPeriod>(
                segments: const [
                  ButtonSegment(value: ReportPeriod.day, label: Text('Day')),
                  ButtonSegment(value: ReportPeriod.week, label: Text('Week')),
                  ButtonSegment(
                    value: ReportPeriod.month,
                    label: Text('Month'),
                  ),
                  ButtonSegment(value: ReportPeriod.year, label: Text('Year')),
                ],
                selected: {_period},
                onSelectionChanged: (s) {
                  setState(() => _period = s.first);
                  _load();
                },
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous',
              ),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Jump to date'),
              ),
              IconButton(
                onPressed: () => _shift(1),
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next',
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () {
                  setState(() => _anchor = DateTime.now());
                  _load();
                },
                icon: const Icon(Icons.today, size: 16),
                label: const Text('Today'),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),

              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: (_loading || _exporting || _summary == null)
                    ? null
                    : _exportPdf,
                icon: _exporting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf, size: 16),
                label: const Text('Export PDF'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // SUMMARY CARDS
  // -----------------------------------------------------------------
  Widget _buildSummaryCards() {
    final s = _summary!;
    final cards = [
      _SummaryCardData(
        'New Borrowers',
        '${s.newBorrowers}',
        Icons.people,
        const Color(0xFF3B82F6),
      ),
      _SummaryCardData(
        'New Loans',
        '${s.newLoans}',
        Icons.description,
        const Color(0xFF8B5CF6),
      ),
      _SummaryCardData(
        'Disbursed',
        _money(s.totalDisbursed),
        Icons.arrow_upward,
        const Color(0xFFEF4444),
      ),
      _SummaryCardData(
        'Collected',
        _money(s.totalCollected),
        Icons.arrow_downward,
        const Color(0xFF10B981),
      ),
      _SummaryCardData(
        'Expenditure',
        _money(s.totalExpenditure),
        Icons.receipt_long,
        const Color(0xFFF59E0B),
      ),
      _SummaryCardData(
        'Net Cash Flow',
        _money(s.netCashFlow),
        Icons.trending_up,
        const Color(0xFF0EA5E9),
      ),
      _SummaryCardData(
        'Active Loans (all time)',
        '${s.activeLoansAllTime}',
        Icons.folder_open,
        const Color(0xFF6366F1),
      ),
      _SummaryCardData(
        'Outstanding (all time)',
        _money(s.outstandingBalanceAllTime),
        Icons.account_balance,
        const Color(0xFF64748B),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth > 1100
              ? (constraints.maxWidth - 24 * 3) / 4
              : (constraints.maxWidth - 24) / 2;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: cards
                .map((c) => SizedBox(width: cardWidth, child: _summaryCard(c)))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _summaryCard(_SummaryCardData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E3E7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------
  // TABS
  // -----------------------------------------------------------------
  Widget _buildTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFF2563EB),
            tabs: [
              Tab(text: 'Loans (${_loans.length})'),
              Tab(text: 'Payments (${_payments.length})'),
              Tab(text: 'Borrowers (${_borrowers.length})'),
              Tab(text: 'Field Officers (${_officers.length})'),
              Tab(text: 'Expenditures (${_expenditures.length})'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _loansTab(),
              _paymentsTab(),
              _borrowersTab(),
              _officersTab(),
              _expendituresTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableShell(List<DataColumn> columns, List<DataRow> rows) {
    if (rows.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text(
            'No records for this period.',
            style: TextStyle(color: Colors.black45),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E3E7)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }

  Widget _loansTab() {
    final rows = _loans.map((l) {
      return DataRow(
        cells: [
          DataCell(Text('${l['loan_number']}')),
          DataCell(Text('${l['borrower_name']}')),
          DataCell(Text('${l['officer_name'] ?? '—'}')),
          DataCell(Text(_money(l['principal_amount']))),
          DataCell(Text(_money(l['total_payable']))),
          DataCell(Text(_money(l['remaining_balance']))),
          DataCell(_statusChip('${l['status']}')),
          DataCell(Text(_shortDate(l['start_date']))),
        ],
      );
    }).toList();

    return _tableShell(const [
      DataColumn(label: Text('Loan #')),
      DataColumn(label: Text('Borrower')),
      DataColumn(label: Text('Field Officer')),
      DataColumn(label: Text('Principal')),
      DataColumn(label: Text('Total Payable')),
      DataColumn(label: Text('Balance')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Start Date')),
    ], rows);
  }

  Widget _paymentsTab() {
    final rows = _payments.map((p) {
      return DataRow(
        cells: [
          DataCell(Text('${p['loan_number']}')),
          DataCell(Text('${p['borrower_name']}')),
          DataCell(Text('${p['officer_name'] ?? '—'}')),
          DataCell(Text(_money(p['amount']))),
          DataCell(Text('${p['payment_type'] ?? '—'}')),
          DataCell(_statusChip('${p['status']}')),
          DataCell(Text(_shortDate(p['payment_date']))),
        ],
      );
    }).toList();

    return _tableShell(const [
      DataColumn(label: Text('Loan #')),
      DataColumn(label: Text('Borrower')),
      DataColumn(label: Text('Field Officer')),
      DataColumn(label: Text('Amount')),
      DataColumn(label: Text('Type')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Payment Date')),
    ], rows);
  }

  Widget _borrowersTab() {
    final rows = _borrowers.map((b) {
      return DataRow(
        cells: [
          DataCell(Text('${b['borrower_number']}')),
          DataCell(Text('${b['full_name']}')),
          DataCell(Text('${b['phone']}')),
          DataCell(Text('${b['district'] ?? '—'}')),
          DataCell(Text('${b['officer_name'] ?? '—'}')),
          DataCell(Text('${b['loan_count']}')),
          DataCell(Text('${b['guarantor_count']}')),
          DataCell(_statusChip('${b['status']}')),
        ],
      );
    }).toList();

    return _tableShell(const [
      DataColumn(label: Text('Borrower #')),
      DataColumn(label: Text('Full Name')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('District')),
      DataColumn(label: Text('Field Officer')),
      DataColumn(label: Text('Loans')),
      DataColumn(label: Text('Guarantors')),
      DataColumn(label: Text('Status')),
    ], rows);
  }

  Widget _officersTab() {
    final rows = _officers.map((o) {
      return DataRow(
        cells: [
          DataCell(Text(o.officerNumber)),
          DataCell(Text(o.name)),
          DataCell(Text('${o.loanCount}')),
          DataCell(Text(_money(o.disbursed))),
          DataCell(Text(_money(o.collected))),
        ],
      );
    }).toList();

    return _tableShell(const [
      DataColumn(label: Text('Officer #')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Loans Issued')),
      DataColumn(label: Text('Disbursed')),
      DataColumn(label: Text('Collected')),
    ], rows);
  }

  Widget _expendituresTab() {
    final rows = _expenditures.map((e) {
      return DataRow(
        cells: [
          DataCell(Text('${e['category_name']}')),
          DataCell(Text('${e['title']}')),
          DataCell(Text(_money(e['amount']))),
          DataCell(Text('${e['payment_method'] ?? '—'}')),
          DataCell(Text(_shortDate(e['expense_date']))),
        ],
      );
    }).toList();

    return _tableShell(const [
      DataColumn(label: Text('Category')),
      DataColumn(label: Text('Title')),
      DataColumn(label: Text('Amount')),
      DataColumn(label: Text('Method')),
      DataColumn(label: Text('Date')),
    ], rows);
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'ACTIVE':
      case 'PAID':
        color = const Color(0xFF10B981);
        break;
      case 'PENDING':
        color = const Color(0xFFF59E0B);
        break;
      case 'OVERDUE':
      case 'DEFAULTED':
        color = const Color(0xFFEF4444);
        break;
      default:
        color = const Color(0xFF64748B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // -----------------------------------------------------------------
  // Formatting helpers (no external `intl` dependency required)
  // -----------------------------------------------------------------
  String _money(Object? value) {
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

  String _shortDate(Object? value) {
    if (value == null) return '—';
    final parsed = DateTime.tryParse('$value');
    if (parsed == null) return '$value';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${parsed.year}-${two(parsed.month)}-${two(parsed.day)}';
  }
}

class _SummaryCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _SummaryCardData(this.label, this.value, this.icon, this.color);
}
