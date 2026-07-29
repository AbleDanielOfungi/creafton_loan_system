import 'package:creafton_financial_services/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'report_models.dart';

/// Pulls all data needed for the financial report screen, using the
/// relationships already defined in DatabaseHelper's schema.
class ReportRepository {
  Future<Database> get _db => DatabaseHelper.database;

  // ---------------------------------------------------------------------
  // LOANS (joined with borrower + field officer)
  // ---------------------------------------------------------------------
  Future<List<Map<String, Object?>>> getLoans(DateRange range) async {
    final db = await _db;
    return db.rawQuery('''
      SELECT
        loans.*,
        borrowers.full_name   AS borrower_name,
        borrowers.phone       AS borrower_phone,
        borrowers.district    AS borrower_district,
        field_officers.full_name     AS officer_name,
        field_officers.officer_number AS officer_number
      FROM loans
      JOIN borrowers ON borrowers.id = loans.borrower_id
      LEFT JOIN field_officers ON field_officers.id = borrowers.field_officer_id
      WHERE loans.created_at BETWEEN ? AND ?
      ORDER BY loans.created_at DESC
    ''', [range.startIso, range.endIso]);
  }

  /// All active loans, regardless of period — used for the portfolio
  /// snapshot (outstanding balance is a running total, not period-bound).
  Future<List<Map<String, Object?>>> getActiveLoansSnapshot() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT loans.*, borrowers.full_name AS borrower_name
      FROM loans
      JOIN borrowers ON borrowers.id = loans.borrower_id
      WHERE loans.status = 'ACTIVE'
    ''');
  }

  // ---------------------------------------------------------------------
  // PAYMENTS (joined with loan + borrower)
  // ---------------------------------------------------------------------
  Future<List<Map<String, Object?>>> getPayments(DateRange range) async {
    final db = await _db;
    return db.rawQuery('''
      SELECT
        loan_payments.*,
        loans.loan_number     AS loan_number,
        borrowers.full_name   AS borrower_name,
        borrowers.id          AS borrower_id,
        field_officers.full_name AS officer_name
      FROM loan_payments
      JOIN loans ON loans.id = loan_payments.loan_id
      JOIN borrowers ON borrowers.id = loans.borrower_id
      LEFT JOIN field_officers ON field_officers.id = borrowers.field_officer_id
      WHERE loan_payments.payment_date BETWEEN ? AND ?
      ORDER BY loan_payments.payment_date DESC
    ''', [range.startIso, range.endIso]);
  }

  // ---------------------------------------------------------------------
  // BORROWERS (new borrowers in period, with guarantor + loan counts)
  // ---------------------------------------------------------------------
  Future<List<Map<String, Object?>>> getBorrowers(DateRange range) async {
    final db = await _db;
    return db.rawQuery('''
      SELECT
        borrowers.*,
        field_officers.full_name AS officer_name,
        (SELECT COUNT(*) FROM guarantors WHERE guarantors.borrower_id = borrowers.id) AS guarantor_count,
        (SELECT COUNT(*) FROM loans WHERE loans.borrower_id = borrowers.id) AS loan_count
      FROM borrowers
      LEFT JOIN field_officers ON field_officers.id = borrowers.field_officer_id
      WHERE borrowers.created_at BETWEEN ? AND ?
      ORDER BY borrowers.created_at DESC
    ''', [range.startIso, range.endIso]);
  }

  Future<List<Map<String, Object?>>> getGuarantorsForBorrower(
    int borrowerId,
  ) async {
    final db = await _db;
    return db.rawQuery(
      'SELECT * FROM guarantors WHERE borrower_id = ? ORDER BY full_name',
      [borrowerId],
    );
  }

  // ---------------------------------------------------------------------
  // EXPENDITURES (joined with category)
  // ---------------------------------------------------------------------
  Future<List<Map<String, Object?>>> getExpenditures(DateRange range) async {
    final db = await _db;
    return db.rawQuery('''
      SELECT
        expenditures.*,
        expenditure_categories.name AS category_name
      FROM expenditures
      JOIN expenditure_categories ON expenditure_categories.id = expenditures.category_id
      WHERE expenditures.expense_date BETWEEN ? AND ?
      ORDER BY expenditures.expense_date DESC
    ''', [range.startIso, range.endIso]);
  }

  // ---------------------------------------------------------------------
  // FIELD OFFICER PERFORMANCE — computed live from loans/payments in the
  // period rather than relying on the (manually-updated) summary table.
  // ---------------------------------------------------------------------
  Future<List<FieldOfficerSummary>> getFieldOfficerSummaries(
    DateRange range,
  ) async {
    final loans = await getLoans(range);
    final payments = await getPayments(range);

    final Map<String, FieldOfficerSummary> byOfficer = {};

    for (final loan in loans) {
      final key = (loan['officer_number'] as String?) ?? 'UNASSIGNED';
      final existing = byOfficer[key];
      final principal = (loan['principal_amount'] as num?)?.toDouble() ?? 0;
      byOfficer[key] = FieldOfficerSummary(
        id: loan['field_officer_id'] as int?,
        name: (loan['officer_name'] as String?) ?? 'Unassigned',
        officerNumber: key,
        loanCount: (existing?.loanCount ?? 0) + 1,
        disbursed: (existing?.disbursed ?? 0) + principal,
        collected: existing?.collected ?? 0,
      );
    }

    for (final payment in payments) {
      final key = (payment['officer_name'] as String?) != null
          ? (payment['officer_name'] as String)
          : 'UNASSIGNED';
      // Match on officer name here since payments query doesn't select
      // officer_number directly; fall back gracefully if unmatched.
      final existing = byOfficer.values.firstWhere(
        (o) => o.name == key,
        orElse: () => FieldOfficerSummary(
          id: null,
          name: key,
          officerNumber: key,
          loanCount: 0,
          disbursed: 0,
          collected: 0,
        ),
      );
      final amount = (payment['amount'] as num?)?.toDouble() ?? 0;
      byOfficer[existing.officerNumber] = FieldOfficerSummary(
        id: existing.id,
        name: existing.name,
        officerNumber: existing.officerNumber,
        loanCount: existing.loanCount,
        disbursed: existing.disbursed,
        collected: existing.collected + amount,
      );
    }

    return byOfficer.values.toList()
      ..sort((a, b) => b.collected.compareTo(a.collected));
  }

  // ---------------------------------------------------------------------
  // SUMMARY
  // ---------------------------------------------------------------------
  Future<ReportSummary> getSummary(DateRange range) async {
    final borrowers = await getBorrowers(range);
    final loans = await getLoans(range);
    final payments = await getPayments(range);
    final expenditures = await getExpenditures(range);
    final activeSnapshot = await getActiveLoansSnapshot();

    double sumNum(List<Map<String, Object?>> rows, String field) {
      return rows.fold<double>(
        0,
        (sum, row) => sum + ((row[field] as num?)?.toDouble() ?? 0),
      );
    }

    return ReportSummary(
      newBorrowers: borrowers.length,
      newLoans: loans.length,
      totalDisbursed: sumNum(loans, 'principal_amount'),
      totalCollected: sumNum(payments, 'amount'),
      totalExpenditure: sumNum(expenditures, 'amount'),
      activeLoansAllTime: activeSnapshot.length,
      outstandingBalanceAllTime: sumNum(activeSnapshot, 'remaining_balance'),
    );
  }
}