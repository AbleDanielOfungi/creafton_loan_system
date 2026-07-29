// import 'package:creafton_financial_services/database/database_helper.dart';
// import 'package:creafton_financial_services/models/reports/report_summary.dart';
// import 'package:sqflite/sqflite.dart';



// class ReportService {
//   ReportService._();

//   static final ReportService instance = ReportService._();

//   Future<Database> get _db async => DatabaseHelper.database;

//   //==========================================================
//   // EXECUTIVE SUMMARY
//   //==========================================================

//   Future<ReportSummary> getExecutiveSummary({
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     final db = await _db;

//     final borrowerCount =
//         Sqflite.firstIntValue(await db.rawQuery('''
//         SELECT COUNT(*)
//         FROM borrowers
//     ''')) ??
//             0;

//     final activeBorrowers =
//         Sqflite.firstIntValue(await db.rawQuery('''
//         SELECT COUNT(*)
//         FROM borrowers
//         WHERE status='ACTIVE'
//     ''')) ??
//             0;

//     final totalLoans =
//         Sqflite.firstIntValue(await db.rawQuery('''
//         SELECT COUNT(*)
//         FROM loans
//     ''')) ??
//             0;

//     final activeLoans =
//         Sqflite.firstIntValue(await db.rawQuery('''
//         SELECT COUNT(*)
//         FROM loans
//         WHERE status='ACTIVE'
//     ''')) ??
//             0;

//     final completedLoans =
//         Sqflite.firstIntValue(await db.rawQuery('''
//         SELECT COUNT(*)
//         FROM loans
//         WHERE status='COMPLETED'
//     ''')) ??
//             0;

//     final principal = await db.rawQuery('''
//       SELECT IFNULL(SUM(principal_amount),0) total
//       FROM loans
//     ''');

//     final interest = await db.rawQuery('''
//       SELECT IFNULL(SUM(interest_amount),0) total
//       FROM loans
//     ''');

//     final payable = await db.rawQuery('''
//       SELECT IFNULL(SUM(total_payable),0) total
//       FROM loans
//     ''');

//     final balance = await db.rawQuery('''
//       SELECT IFNULL(SUM(remaining_balance),0) total
//       FROM loans
//     ''');

//     final collected = await db.rawQuery('''
//       SELECT IFNULL(SUM(amount),0) total
//       FROM loan_payments
//       WHERE status='PAID'
//     ''');

//     final expenses = await db.rawQuery('''
//       SELECT IFNULL(SUM(amount),0) total
//       FROM expenditures
//     ''');

//     final todayCollections = await db.rawQuery('''
//       SELECT IFNULL(SUM(amount),0) total
//       FROM loan_payments
//       WHERE payment_date = DATE('now')
//       AND status='PAID'
//     ''');

//     final monthlyCollections = await db.rawQuery('''
//       SELECT IFNULL(SUM(amount),0) total
//       FROM loan_payments
//       WHERE strftime('%Y-%m',payment_date)=strftime('%Y-%m','now')
//       AND status='PAID'
//     ''');

//     final totalPrincipal =
//         (principal.first['total'] as num?)?.toDouble() ?? 0;

//     final totalInterest =
//         (interest.first['total'] as num?)?.toDouble() ?? 0;

//     final totalPortfolio =
//         (payable.first['total'] as num?)?.toDouble() ?? 0;

//     final outstanding =
//         (balance.first['total'] as num?)?.toDouble() ?? 0;

//     final totalCollected =
//         (collected.first['total'] as num?)?.toDouble() ?? 0;

//     final totalExpenses =
//         (expenses.first['total'] as num?)?.toDouble() ?? 0;

//     final today =
//         (todayCollections.first['total'] as num?)?.toDouble() ?? 0;

//     final month =
//         (monthlyCollections.first['total'] as num?)?.toDouble() ?? 0;

//     return ReportSummary(
//       totalBorrowers: borrowerCount,
//       activeBorrowers: activeBorrowers,
//       totalLoans: totalLoans,
//       activeLoans: activeLoans,
//       completedLoans: completedLoans,
//       totalPrincipal: totalPrincipal,
//       totalInterest: totalInterest,
//       totalPortfolio: totalPortfolio,
//       totalCollected: totalCollected,
//       outstandingBalance: outstanding,
//       todayCollections: today,
//       monthlyCollections: month,
//       totalExpenses: totalExpenses,
//       netIncome: totalCollected - totalExpenses,
//     );
//   }

//   //==========================================================
//   // BORROWERS REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getBorrowersReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// b.id,

// b.borrower_number,

// b.full_name,

// b.phone,

// b.district,

// b.status,

// f.full_name AS field_officer,

// IFNULL(bs.total_borrowed,0) total_borrowed,

// IFNULL(bs.total_paid,0) total_paid,

// IFNULL(bs.outstanding_balance,0) outstanding_balance,

// IFNULL(bs.repayment_score,0) repayment_score

// FROM borrowers b

// LEFT JOIN field_officers f

// ON b.field_officer_id=f.id

// LEFT JOIN borrower_statistics bs

// ON bs.borrower_id=b.id

// ORDER BY b.full_name
// ''');
//   }

//   //==========================================================
//   // LOAN REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getLoansReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// l.loan_number,

// b.full_name borrower,

// l.principal_amount,

// l.interest_amount,

// l.total_payable,

// l.remaining_balance,

// l.daily_payment_amount,

// l.loan_duration,

// l.start_date,

// l.end_date,

// l.status

// FROM loans l

// INNER JOIN borrowers b

// ON b.id=l.borrower_id

// ORDER BY l.created_at DESC
// ''');
//   }

//   //==========================================================
//   // PAYMENTS REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getPaymentsReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// lp.payment_number,

// lp.payment_type,

// lp.amount,

// lp.payment_date,

// lp.due_date,

// lp.status,

// b.full_name borrower,

// l.loan_number

// FROM loan_payments lp

// INNER JOIN loans l

// ON lp.loan_id=l.id

// INNER JOIN borrowers b

// ON b.id=l.borrower_id

// ORDER BY lp.payment_date DESC
// ''');
//   }

//   //==========================================================
//   // ARREARS REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getArrearsReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// b.full_name,

// l.loan_number,

// lp.amount,

// lp.due_date,

// julianday('now')-julianday(lp.due_date)
// AS days_overdue

// FROM loan_payments lp

// INNER JOIN loans l

// ON lp.loan_id=l.id

// INNER JOIN borrowers b

// ON l.borrower_id=b.id

// WHERE

// lp.status='PENDING'

// AND

// DATE(lp.due_date)<DATE('now')

// ORDER BY days_overdue DESC
// ''');
//   }

//   //==========================================================
//   // FIELD OFFICER REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getFieldOfficerReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// f.officer_number,

// f.full_name,

// f.phone,

// p.total_assigned,

// p.active_loans,

// p.completed_loans,

// p.overdue_loans,

// p.total_collected,

// p.outstanding_amount,

// p.recovery_rate,

// p.performance_score

// FROM field_officers f

// LEFT JOIN field_officer_performance p

// ON p.field_officer_id=f.id

// ORDER BY performance_score DESC
// ''');
//   }

//   //==========================================================
//   // EXPENDITURE REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getExpenditureReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// e.title,

// c.name category,

// e.amount,

// e.payment_method,

// e.reference_number,

// e.expense_date

// FROM expenditures e

// INNER JOIN expenditure_categories c

// ON e.category_id=c.id

// ORDER BY e.expense_date DESC
// ''');
//   }

//   //==========================================================
//   // GUARANTOR REPORT
//   //==========================================================

//   Future<List<Map<String, dynamic>>> getGuarantorReport() async {
//     final db = await _db;

//     return db.rawQuery('''
// SELECT

// g.full_name,

// g.relationship,

// g.phone,

// g.national_id,

// b.full_name borrower

// FROM guarantors g

// INNER JOIN borrowers b

// ON g.borrower_id=b.id

// ORDER BY g.full_name
// ''');
//   }

//   //==========================================================
//   // COLLECTION TOTALS
//   //==========================================================

//   Future<double> totalCollections() async {
//     final db = await _db;

//     final result = await db.rawQuery('''
// SELECT IFNULL(SUM(amount),0) total
// FROM loan_payments
// WHERE status='PAID'
// ''');

//     return (result.first['total'] as num?)?.toDouble() ?? 0;
//   }

//   Future<double> totalExpenses() async {
//     final db = await _db;

//     final result = await db.rawQuery('''
// SELECT IFNULL(SUM(amount),0) total
// FROM expenditures
// ''');

//     return (result.first['total'] as num?)?.toDouble() ?? 0;
//   }

//   Future<double> netIncome() async {
//     final income = await totalCollections();
//     final expenses = await totalExpenses();

//     return income - expenses;
//   }
// }