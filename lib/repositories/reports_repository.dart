import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class ReportsRepository {
  Future<Database> get _db async => await DatabaseHelper.database;

  // =====================================================
  // DASHBOARD TOTALS
  // =====================================================

  Future<int> totalBorrowers() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM borrowers
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }



  Future<int> totalFieldOfficers() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM field_officers
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> totalGuarantors() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM guarantors
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> totalLoans() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM loans
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> activeLoans() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM loans
      WHERE status='ACTIVE'
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> completedLoans() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM loans
      WHERE status='COMPLETED'
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> overdueLoans() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) total
      FROM loan_payments
      WHERE status='PENDING'
      AND due_date < date('now')
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // =====================================================
  // MONEY
  // =====================================================

  Future<double> totalPrincipalLent() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(principal_amount) total
      FROM loans
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  Future<double> totalInterest() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(interest_amount) total
      FROM loans
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  Future<double> totalPayable() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(total_payable) total
      FROM loans
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  Future<double> outstandingBalance() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(remaining_balance) total
      FROM loans
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  Future<double> totalCollected() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM loan_payments
      WHERE status='PAID'
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  Future<double> totalExpenses() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM expenditures
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  // =====================================================
  // TODAY COLLECTION
  // =====================================================

  Future<double> todayCollections() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM loan_payments
      WHERE payment_date=date('now')
      AND status='PAID'
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  // =====================================================
  // TODAY EXPENSES
  // =====================================================

  Future<double> todayExpenses() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM expenditures
      WHERE expense_date=date('now')
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  // =====================================================
  // WEEK COLLECTIONS
  // =====================================================

  Future<double> weeklyCollections() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM loan_payments
      WHERE payment_date>=date('now','-6 day')
      AND status='PAID'
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  // =====================================================
  // MONTH COLLECTIONS
  // =====================================================

  Future<double> monthlyCollections() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM loan_payments
      WHERE strftime('%Y-%m',payment_date)=strftime('%Y-%m','now')
      AND status='PAID'
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  // =====================================================
  // YEAR COLLECTIONS
  // =====================================================

  Future<double> yearlyCollections() async {
    final db = await _db;

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) total
      FROM loan_payments
      WHERE strftime('%Y',payment_date)=strftime('%Y','now')
      AND status='PAID'
      ''',
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0;
  }

  // =====================================================
  // LOANS DUE TODAY
  // =====================================================

  Future<List<Map<String, dynamic>>> loansDueToday() async {
    final db = await _db;

    return db.rawQuery('''
SELECT

borrowers.borrower_number,

borrowers.full_name,

borrowers.phone,

loans.loan_number,

loan_payments.amount,

loan_payments.due_date

FROM loan_payments

INNER JOIN loans
ON loans.id=loan_payments.loan_id

INNER JOIN borrowers
ON borrowers.id=loans.borrower_id

WHERE loan_payments.status='PENDING'

AND loan_payments.due_date=date('now')

ORDER BY borrowers.full_name

''');
  }

  // =====================================================
  // UPCOMING PAYMENTS
  // =====================================================

  Future<List<Map<String, dynamic>>> upcomingPayments() async {
    final db = await _db;

    return db.rawQuery('''
SELECT

borrowers.borrower_number,

borrowers.full_name,

borrowers.phone,

loans.loan_number,

loan_payments.amount,

loan_payments.due_date

FROM loan_payments

INNER JOIN loans
ON loans.id=loan_payments.loan_id

INNER JOIN borrowers
ON borrowers.id=loans.borrower_id

WHERE loan_payments.status='PENDING'

ORDER BY loan_payments.due_date ASC

LIMIT 30

''');
  }

  // =====================================================
  // DEFAULTERS
  // =====================================================

  Future<List<Map<String, dynamic>>> defaulters() async {
    final db = await _db;

    return db.rawQuery('''
SELECT

borrowers.borrower_number,

borrowers.full_name,

borrowers.phone,

loans.loan_number,

loans.remaining_balance,

loan_payments.due_date,

field_officers.full_name AS officer

FROM loan_payments

INNER JOIN loans
ON loans.id=loan_payments.loan_id

INNER JOIN borrowers
ON borrowers.id=loans.borrower_id

LEFT JOIN field_officers
ON field_officers.id=borrowers.field_officer_id

WHERE loan_payments.status='PENDING'

AND loan_payments.due_date<date('now')

ORDER BY loan_payments.due_date ASC

''');
  }

  // =====================================================
  // BORROWER REPORT
  // =====================================================

  Future<List<Map<String, dynamic>>> borrowerReport() async {
    final db = await _db;

    return db.rawQuery('''
SELECT

borrowers.*,

field_officers.full_name AS field_officer,

guarantors.full_name AS guarantor,

loans.loan_number,

loans.principal_amount,

loans.remaining_balance,

loans.status AS loan_status

FROM borrowers

LEFT JOIN field_officers
ON field_officers.id=borrowers.field_officer_id

LEFT JOIN guarantors
ON guarantors.borrower_id=borrowers.id

LEFT JOIN loans
ON loans.borrower_id=borrowers.id

ORDER BY borrowers.full_name

''');
  }

  // =====================================================
  // FIELD OFFICER PERFORMANCE
  // =====================================================

  Future<List<Map<String, dynamic>>> fieldOfficerPerformance() async {
    final db = await _db;

    return db.query(
      "field_officer_performance",
      orderBy: "performance_score DESC",
    );
  }

  // =====================================================
  // EXPENDITURE REPORT
  // =====================================================

  Future<List<Map<String, dynamic>>> expenditureReport() async {
    final db = await _db;

    return db.rawQuery('''
SELECT

expenditures.*,

expenditure_categories.name category

FROM expenditures

INNER JOIN expenditure_categories

ON expenditure_categories.id=expenditures.category_id

ORDER BY expense_date DESC

''');
  }

  // =====================================================
// CUSTOM LOANS REPORT
// =====================================================

Future<List<Map<String, dynamic>>> customLoans(
  DateTime from,
  DateTime to,
) async {
  final db = await DatabaseHelper.database;

  return await db.rawQuery(
    '''
    SELECT

      loans.*,

      borrowers.borrower_number,
      borrowers.full_name,
      borrowers.phone,

      field_officers.full_name AS field_officer

    FROM loans

    INNER JOIN borrowers
      ON borrowers.id = loans.borrower_id

    LEFT JOIN field_officers
      ON field_officers.id = borrowers.field_officer_id

    WHERE date(loans.created_at)

    BETWEEN date(?)

    AND date(?)

    ORDER BY loans.created_at DESC
    ''',
    [
      from.toIso8601String(),
      to.toIso8601String(),
    ],
  );
}

//////////////////////////////////////////////////////////
// CUSTOM PAYMENTS REPORT
//////////////////////////////////////////////////////////

Future<List<Map<String, dynamic>>> customPayments(
  DateTime from,
  DateTime to,
) async {
  final db = await DatabaseHelper.database;

  return await db.rawQuery(
    '''
    SELECT

      loan_payments.*,

      loans.loan_number,

      borrowers.borrower_number,
      borrowers.full_name,

      field_officers.full_name AS field_officer

    FROM loan_payments

    INNER JOIN loans

      ON loans.id = loan_payments.loan_id

    INNER JOIN borrowers

      ON borrowers.id = loans.borrower_id

    LEFT JOIN field_officers

      ON field_officers.id = borrowers.field_officer_id

    WHERE date(loan_payments.payment_date)

    BETWEEN date(?)

    AND date(?)

    ORDER BY loan_payments.payment_date DESC
    ''',
    [
      from.toIso8601String(),
      to.toIso8601String(),
    ],
  );
}

//////////////////////////////////////////////////////////
// CUSTOM DEFAULTERS REPORT
//////////////////////////////////////////////////////////

Future<List<Map<String, dynamic>>> customDefaulters(
  DateTime from,
  DateTime to,
) async {
  final db = await DatabaseHelper.database;

  return await db.rawQuery(
    '''
    SELECT

      loans.*,

      borrowers.borrower_number,
      borrowers.full_name,
      borrowers.phone,

      guarantors.full_name AS guarantor,

      field_officers.full_name AS field_officer

    FROM loans

    INNER JOIN borrowers

      ON borrowers.id = loans.borrower_id

    LEFT JOIN guarantors

      ON guarantors.borrower_id = borrowers.id

    LEFT JOIN field_officers

      ON field_officers.id = borrowers.field_officer_id

    WHERE

      loans.status='ACTIVE'

      AND

      loans.remaining_balance>0

      AND

      date(loans.end_date)

      BETWEEN date(?)

      AND date(?)

    ORDER BY loans.end_date
    ''',
    [
      from.toIso8601String(),
      to.toIso8601String(),
    ],
  );
}

Future<List<Map<String, dynamic>>> dailyCollectionTrend() async {

  final db = await DatabaseHelper.database;

  return await db.rawQuery("""

SELECT
DATE(payment_date) AS label,
SUM(amount) AS amount

FROM loan_payments

WHERE payment_date IS NOT NULL

GROUP BY DATE(payment_date)

ORDER BY DATE(payment_date)

LIMIT 7

""");

}

// ======================================================
// DAILY COLLECTION TREND
// ======================================================

// Future<List<Map<String, dynamic>>> dailyCollectionTrend() async {
//   final db = await DatabaseHelper.database;

//   return await db.rawQuery("""
//     SELECT
//       DATE(payment_date) AS label,
//       SUM(amount) AS amount
//     FROM loan_payments
//     WHERE payment_date IS NOT NULL
//     GROUP BY DATE(payment_date)
//     ORDER BY DATE(payment_date) ASC
//     LIMIT 7
//   """);
// }

// ======================================================
// WEEKLY COLLECTION TREND
// ======================================================

Future<List<Map<String, dynamic>>> weeklyCollectionTrend() async {
  final db = await DatabaseHelper.database;

  return await db.rawQuery("""
    SELECT
      strftime('%W', payment_date) AS label,
      SUM(amount) AS amount
    FROM loan_payments
    WHERE payment_date IS NOT NULL
    GROUP BY strftime('%W', payment_date)
    ORDER BY strftime('%W', payment_date) ASC
    LIMIT 12
  """);
}

// ======================================================
// MONTHLY COLLECTION TREND
// ======================================================

Future<List<Map<String, dynamic>>> monthlyCollectionTrend() async {
  final db = await DatabaseHelper.database;

  return await db.rawQuery("""
    SELECT
      strftime('%m', payment_date) AS label,
      SUM(amount) AS amount
    FROM loan_payments
    WHERE payment_date IS NOT NULL
    GROUP BY strftime('%m', payment_date)
    ORDER BY strftime('%m', payment_date) ASC
  """);
}

// ======================================================
// YEARLY COLLECTION TREND
// ======================================================

Future<List<Map<String, dynamic>>> yearlyCollectionTrend() async {
  final db = await DatabaseHelper.database;

  return await db.rawQuery("""
    SELECT
      strftime('%Y', payment_date) AS label,
      SUM(amount) AS amount
    FROM loan_payments
    WHERE payment_date IS NOT NULL
    GROUP BY strftime('%Y', payment_date)
    ORDER BY strftime('%Y', payment_date) ASC
  """);
}



}