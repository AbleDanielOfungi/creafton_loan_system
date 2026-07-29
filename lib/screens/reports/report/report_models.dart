/// Simple period selector for report filtering.
enum ReportPeriod { day, week, month, year, custom }

class DateRange {
  final DateTime start;
  final DateTime end; // inclusive, end-of-day

  const DateRange(this.start, this.end);

  /// Builds a range for the given [period] anchored on [anchor].
  factory DateRange.forPeriod(ReportPeriod period, DateTime anchor) {
    switch (period) {
      case ReportPeriod.day:
        return DateRange(
          DateTime(anchor.year, anchor.month, anchor.day),
          DateTime(anchor.year, anchor.month, anchor.day, 23, 59, 59),
        );
      case ReportPeriod.week:
        // Monday -> Sunday containing anchor
        final weekday = anchor.weekday; // 1 = Monday .. 7 = Sunday
        final monday = anchor.subtract(Duration(days: weekday - 1));
        final start = DateTime(monday.year, monday.month, monday.day);
        final end = start
            .add(const Duration(days: 6))
            .add(const Duration(hours: 23, minutes: 59, seconds: 59));
        return DateRange(start, end);
      case ReportPeriod.month:
        final start = DateTime(anchor.year, anchor.month, 1);
        final lastDay = DateTime(anchor.year, anchor.month + 1, 0).day;
        final end = DateTime(anchor.year, anchor.month, lastDay, 23, 59, 59);
        return DateRange(start, end);
      case ReportPeriod.year:
        return DateRange(
          DateTime(anchor.year, 1, 1),
          DateTime(anchor.year, 12, 31, 23, 59, 59),
        );
      case ReportPeriod.custom:
        return DateRange(anchor, anchor);
    }
  }

  String get startIso => start.toIso8601String();
  String get endIso => end.toIso8601String();

  String get label {
    String two(int n) => n.toString().padLeft(2, '0');
    String fmt(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
    return '${fmt(start)}  →  ${fmt(end)}';
  }
}

class ReportSummary {
  final int newBorrowers;
  final int newLoans;
  final double totalDisbursed;
  final double totalCollected;
  final double totalExpenditure;
  final int activeLoansAllTime;
  final double outstandingBalanceAllTime;

  const ReportSummary({
    required this.newBorrowers,
    required this.newLoans,
    required this.totalDisbursed,
    required this.totalCollected,
    required this.totalExpenditure,
    required this.activeLoansAllTime,
    required this.outstandingBalanceAllTime,
  });

  double get netCashFlow => totalCollected - totalExpenditure;
}

class FieldOfficerSummary {
  final int? id;
  final String name;
  final String officerNumber;
  final int loanCount;
  final double disbursed;
  final double collected;

  FieldOfficerSummary({
    required this.id,
    required this.name,
    required this.officerNumber,
    required this.loanCount,
    required this.disbursed,
    required this.collected,
  });
}