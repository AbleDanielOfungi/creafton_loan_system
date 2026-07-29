import 'package:creafton_financial_services/database/database_helper.dart';


/// A single row in the "recent payments" feed.
class RecentPayment {
  final String borrowerName;
  final String loanNumber;
  final double amount;
  final String? paymentDate;
  final String status;

  RecentPayment({
    required this.borrowerName,
    required this.loanNumber,
    required this.amount,
    required this.paymentDate,
    required this.status,
  });
}

/// A single row for the "top field officers" leaderboard.
class OfficerPerformance {
  final String fullName;
  final double totalCollected;
  final double recoveryRate;
  final int activeLoans;
  final double performanceScore;

  OfficerPerformance({
    required this.fullName,
    required this.totalCollected,
    required this.recoveryRate,
    required this.activeLoans,
    required this.performanceScore,
  });
}

/// A single row for the "recently onboarded borrowers" list.
class RecentBorrower {
  final String fullName;
  final String borrowerNumber;
  final String phone;
  final String? createdAt;
  final String status;

  RecentBorrower({
    required this.fullName,
    required this.borrowerNumber,
    required this.phone,
    required this.createdAt,
    required this.status,
  });
}

/// Aggregated snapshot of everything the dashboard needs to render.
class DashboardStats {
  final String businessName;
  final String currency;

  final int totalBorrowers;
  final int activeBorrowers;

  final int totalLoans;
  final int activeLoans;
  final int completedLoans;
  final int overdueLoans;

  final double totalPortfolio; // outstanding balance on active loans
  final double totalDisbursed; // sum of all principal ever issued

  final double collectedToday;
  final double collectedThisMonth;
  final double collectedAllTime;

  final double expendituresThisMonth;

  final int totalFieldOfficers;
  final int activeFieldOfficers;

  final Map<String, int> loanStatusBreakdown;
  final List<RecentPayment> recentPayments;
  final List<OfficerPerformance> topOfficers;
  final List<RecentBorrower> recentBorrowers;

  DashboardStats({
    required this.businessName,
    required this.currency,
    required this.totalBorrowers,
    required this.activeBorrowers,
    required this.totalLoans,
    required this.activeLoans,
    required this.completedLoans,
    required this.overdueLoans,
    required this.totalPortfolio,
    required this.totalDisbursed,
    required this.collectedToday,
    required this.collectedThisMonth,
    required this.collectedAllTime,
    required this.expendituresThisMonth,
    required this.totalFieldOfficers,
    required this.activeFieldOfficers,
    required this.loanStatusBreakdown,
    required this.recentPayments,
    required this.topOfficers,
    required this.recentBorrowers,
  });

  /// Net cash position for the month (collections - expenses).
  double get netThisMonth => collectedThisMonth - expendituresThisMonth;

  /// % of portfolio principal collected so far (very rough recovery rate).
  double get overallRecoveryRate {
    if (totalDisbursed <= 0) return 0;
    return (collectedAllTime / totalDisbursed).clamp(0, 1) * 100;
  }
}

class DashboardRepository {
  /// Runs every dashboard query and assembles a [DashboardStats] snapshot.
  static Future<DashboardStats> loadDashboard() async {
    final db = await DatabaseHelper.database;

    final businessRow = await db.query('business_settings', limit: 1);
    final businessName = businessRow.isNotEmpty
        ? (businessRow.first['business_name'] as String?) ?? 'My Business'
        : 'My Business';
    final currency = businessRow.isNotEmpty
        ? (businessRow.first['currency'] as String?) ?? 'UGX'
        : 'UGX';

    final borrowerRow = await db.rawQuery('''
      SELECT
        COUNT(*) AS total,
        SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active
      FROM borrowers
    ''');

    final loanRow = await db.rawQuery('''
      SELECT
        COUNT(*) AS total,
        SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active,
        SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed,
        SUM(CASE WHEN status = 'OVERDUE' THEN 1 ELSE 0 END) AS overdue,
        SUM(CASE WHEN status = 'ACTIVE' THEN remaining_balance ELSE 0 END) AS portfolio,
        SUM(principal_amount) AS disbursed
      FROM loans
    ''');

    final loanStatusRows = await db.rawQuery('''
      SELECT status, COUNT(*) AS cnt FROM loans GROUP BY status
    ''');

    final collectedTodayRow = await db.rawQuery('''
      SELECT SUM(amount) AS total FROM loan_payments
      WHERE status = 'PAID' AND date(payment_date) = date('now', 'localtime')
    ''');

    final collectedMonthRow = await db.rawQuery('''
      SELECT SUM(amount) AS total FROM loan_payments
      WHERE status = 'PAID'
        AND strftime('%Y-%m', payment_date) = strftime('%Y-%m', 'now', 'localtime')
    ''');

    final collectedAllTimeRow = await db.rawQuery('''
      SELECT SUM(amount) AS total FROM loan_payments WHERE status = 'PAID'
    ''');

    final expensesMonthRow = await db.rawQuery('''
      SELECT SUM(amount) AS total FROM expenditures
      WHERE strftime('%Y-%m', expense_date) = strftime('%Y-%m', 'now', 'localtime')
    ''');

    final officerRow = await db.rawQuery('''
      SELECT
        COUNT(*) AS total,
        SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) AS active
      FROM field_officers
    ''');

    final recentPaymentRows = await db.rawQuery('''
      SELECT lp.amount, lp.payment_date, lp.status, l.loan_number, b.full_name
      FROM loan_payments lp
      JOIN loans l ON l.id = lp.loan_id
      JOIN borrowers b ON b.id = l.borrower_id
      ORDER BY lp.payment_date DESC, lp.id DESC
      LIMIT 10
    ''');

    final topOfficerRows = await db.rawQuery('''
      SELECT fo.full_name, fop.total_collected, fop.recovery_rate,
             fop.active_loans, fop.performance_score
      FROM field_officer_performance fop
      JOIN field_officers fo ON fo.id = fop.field_officer_id
      ORDER BY fop.performance_score DESC
      LIMIT 5
    ''');

    final recentBorrowerRows = await db.rawQuery('''
      SELECT full_name, borrower_number, phone, created_at, status
      FROM borrowers
      ORDER BY created_at DESC
      LIMIT 5
    ''');

    double asDouble(Object? v) => (v as num?)?.toDouble() ?? 0.0;
    int asInt(Object? v) => (v as num?)?.toInt() ?? 0;

    final loanStatusBreakdown = <String, int>{
      for (final row in loanStatusRows)
        (row['status'] as String? ?? 'UNKNOWN'): asInt(row['cnt']),
    };

    return DashboardStats(
      businessName: businessName,
      currency: currency,
      totalBorrowers: asInt(borrowerRow.first['total']),
      activeBorrowers: asInt(borrowerRow.first['active']),
      totalLoans: asInt(loanRow.first['total']),
      activeLoans: asInt(loanRow.first['active']),
      completedLoans: asInt(loanRow.first['completed']),
      overdueLoans: asInt(loanRow.first['overdue']),
      totalPortfolio: asDouble(loanRow.first['portfolio']),
      totalDisbursed: asDouble(loanRow.first['disbursed']),
      collectedToday: asDouble(collectedTodayRow.first['total']),
      collectedThisMonth: asDouble(collectedMonthRow.first['total']),
      collectedAllTime: asDouble(collectedAllTimeRow.first['total']),
      expendituresThisMonth: asDouble(expensesMonthRow.first['total']),
      totalFieldOfficers: asInt(officerRow.first['total']),
      activeFieldOfficers: asInt(officerRow.first['active']),
      loanStatusBreakdown: loanStatusBreakdown,
      recentPayments: recentPaymentRows
          .map((r) => RecentPayment(
                borrowerName: r['full_name'] as String? ?? '—',
                loanNumber: r['loan_number'] as String? ?? '—',
                amount: asDouble(r['amount']),
                paymentDate: r['payment_date'] as String?,
                status: r['status'] as String? ?? 'PENDING',
              ))
          .toList(),
      topOfficers: topOfficerRows
          .map((r) => OfficerPerformance(
                fullName: r['full_name'] as String? ?? '—',
                totalCollected: asDouble(r['total_collected']),
                recoveryRate: asDouble(r['recovery_rate']),
                activeLoans: asInt(r['active_loans']),
                performanceScore: asDouble(r['performance_score']),
              ))
          .toList(),
      recentBorrowers: recentBorrowerRows
          .map((r) => RecentBorrower(
                fullName: r['full_name'] as String? ?? '—',
                borrowerNumber: r['borrower_number'] as String? ?? '—',
                phone: r['phone'] as String? ?? '—',
                createdAt: r['created_at'] as String?,
                status: r['status'] as String? ?? 'ACTIVE',
              ))
          .toList(),
    );
  }
}