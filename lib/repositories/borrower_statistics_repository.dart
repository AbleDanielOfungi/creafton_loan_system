import 'package:creafton_financial_services/models/borrower_statistics.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';

class BorrowerStatisticsRepository {
  Future<Database> get db async {
    return await DatabaseHelper.database;
  }

  // =====================================================
  // GET BORROWER STATISTICS
  // =====================================================

  Future<BorrowerStatistics?> getByBorrower(int borrowerId) async {
    final database = await db;

    final result = await database.query(
      "borrower_statistics",

      where: "borrower_id = ?",

      whereArgs: [borrowerId],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return BorrowerStatistics.fromMap(result.first);
  }

  // =====================================================
  // CREATE INITIAL STATISTICS
  // =====================================================

  Future<int> createInitial(int borrowerId) async {
    final database = await db;

    return await database.insert("borrower_statistics", {
      "borrower_id": borrowerId,

      "total_loans": 0,

      "active_loans": 0,

      "completed_loans": 0,

      "total_borrowed": 0,

      "total_paid": 0,

      "outstanding_balance": 0,

      "total_payments": 0,

      "late_payments": 0,

      "missed_payments": 0,

      "repayment_score": 0,

      "created_at": DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // =====================================================
  // UPDATE AFTER LOAN CREATION
  // =====================================================

  Future<void> addLoan(int borrowerId, double amount) async {
    final database = await db;

    await database.rawUpdate(
      '''

UPDATE borrower_statistics

SET

total_loans = total_loans + 1,


active_loans = active_loans + 1,


total_borrowed = total_borrowed + ?,


outstanding_balance =
outstanding_balance + ?,


repayment_score =
CASE

WHEN total_borrowed + ? = 0 THEN 0

ELSE

(total_paid /
(total_borrowed + ?))*100

END


WHERE borrower_id = ?

''',

      [amount, amount, amount, amount, borrowerId],
    );
  }

  // =====================================================
  // UPDATE AFTER PAYMENT
  // =====================================================

  //   Future<void> addPayment(
  //     int borrowerId,

  //     double amount,

  //     String paymentDate,
  //   ) async {
  //     final database = await db;

  //     await database.rawUpdate(
  //       '''

  // UPDATE borrower_statistics

  // SET

  // total_paid =
  // total_paid + ?,

  // outstanding_balance =
  // CASE

  // WHEN outstanding_balance - ? < 0

  // THEN 0

  // ELSE outstanding_balance - ?

  // END,

  // total_payments =
  // total_payments + 1,

  // last_payment_date = ?,

  // repayment_score =

  // CASE

  // WHEN total_borrowed = 0

  // THEN 0

  // ELSE

  // ((total_paid + ?) /

  // total_borrowed) * 100

  // END

  // WHERE borrower_id = ?

  // ''',

  //       [amount, amount, amount, paymentDate, amount, borrowerId],
  //     );
  //   }

  // =====================================================
  // UPDATE AFTER PAYMENT
  // =====================================================

  Future<void> addPayment(
    int borrowerId,
    double amount,
    String paymentDate,
  ) async {
    final database = await db;

    // Ensure statistics row exists
    final existing = await database.query(
      "borrower_statistics",
      where: "borrower_id=?",
      whereArgs: [borrowerId],
    );

    if (existing.isEmpty) {
      await createInitial(borrowerId);
    }

    await database.rawUpdate(
      '''

UPDATE borrower_statistics

SET


total_paid = total_paid + ?,


outstanding_balance =
CASE

WHEN outstanding_balance - ? < 0

THEN 0

ELSE outstanding_balance - ?

END,


total_payments =
total_payments + 1,


last_payment_date = ?,


repayment_score =

CASE

WHEN total_borrowed = 0

THEN 0


ELSE

((total_paid + ?) / total_borrowed) * 100


END


WHERE borrower_id = ?


''',

      [amount, amount, amount, paymentDate, amount, borrowerId],
    );
  }

  // =====================================================
  // MARK LOAN COMPLETED
  // =====================================================

  Future<void> completeLoan(int borrowerId) async {
    final database = await db;

    await database.rawUpdate(
      '''


UPDATE borrower_statistics


SET


active_loans =

CASE

WHEN active_loans > 0

THEN active_loans - 1

ELSE 0

END,



completed_loans =
completed_loans + 1



WHERE borrower_id = ?



''',

      [borrowerId],
    );
  }

  // =====================================================
  // ADD MISSED PAYMENT
  // =====================================================

  Future<void> addMissedPayment(int borrowerId) async {
    final database = await db;

    await database.rawUpdate(
      '''

UPDATE borrower_statistics


SET


missed_payments =
missed_payments + 1,


repayment_score =

CASE

WHEN repayment_score - 5 < 0

THEN 0


ELSE repayment_score - 5


END


WHERE borrower_id = ?

''',

      [borrowerId],
    );
  }

  // =====================================================
  // ADD LATE PAYMENT
  // =====================================================

  Future<void> addLatePayment(int borrowerId) async {
    final database = await db;

    await database.rawUpdate(
      '''


UPDATE borrower_statistics


SET


late_payments =
late_payments + 1,



repayment_score =


CASE


WHEN repayment_score - 2 < 0

THEN 0



ELSE repayment_score - 2



END



WHERE borrower_id = ?


''',

      [borrowerId],
    );
  }

  // =====================================================
  // DELETE STATISTICS
  // =====================================================

  Future<void> delete(int borrowerId) async {
    final database = await db;

    await database.delete(
      "borrower_statistics",

      where: "borrower_id = ?",

      whereArgs: [borrowerId],
    );
  }
}
