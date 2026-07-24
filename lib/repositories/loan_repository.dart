import 'package:creafton_financial_services/core/utils/payment_schedule_generator.dart';
import 'package:creafton_financial_services/models/loan.dart';
import 'package:creafton_financial_services/repositories/payment_schedule_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';

class LoanRepository {
  final PaymentScheduleRepository scheduleRepository =
      PaymentScheduleRepository();

  Future<Database> get db async {
    return await DatabaseHelper.database;
  }

  // Future<int> create(Loan loan) async {
  //   final db = await DatabaseHelper.database;

  //   final loanId = await db.insert("loans", loan.toMap());

  //   final schedule = PaymentScheduleGenerator.generate(
  //     loanId: loanId,

  //     dailyPayment: loan.dailyPaymentAmount!,

  //     duration: loan.loanDuration!,

  //     startDate: DateTime.parse(loan.startDate!),
  //   );

  //   await scheduleRepository.createSchedule(schedule);

  //   return loanId;
  // }

  Future<int> create(Loan loan) async {
    final database = await DatabaseHelper.database;

    int loanId = 0;

    await database.transaction((txn) async {
      loanId = await txn.insert("loans", loan.toMap());

      final schedule = PaymentScheduleGenerator.generate(
        loanId: loanId,

        installmentAmount: loan.dailyPaymentAmount,

        duration: loan.loanDuration,

        startDate: DateTime.parse(loan.startDate),

        frequency: loan.paymentFrequency,
      );

      await scheduleRepository.createSchedule(schedule, database: txn);
    });

    return loanId;
  }

  // =========================================================
  // UPDATE LOAN
  // =========================================================

  Future<int> updateLoan(Loan loan) async {
    final database = await db;

    return await database.update(
      "loans",

      loan.toMap(),

      where: "id=?",

      whereArgs: [loan.id],
    );
  }

  // =========================================================
  // DELETE LOAN
  // =========================================================

  Future<int> deleteLoan(int loanId) async {
    final database = await db;

    return await database.delete("loans", where: "id=?", whereArgs: [loanId]);
  }

  // =========================================================
  // GET LOAN BY ID
  // =========================================================

  Future<Loan?> getLoanById(int loanId) async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: "id=?",

      whereArgs: [loanId],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Loan.fromMap(result.first);
  }

  // =========================================================
  // GET ALL LOANS
  // =========================================================

  Future<List<Loan>> getAllLoans() async {
    final database = await db;

    final result = await database.query("loans", orderBy: "id DESC");

    return result.map((e) => Loan.fromMap(e)).toList();
  }

  // =========================================================
  // GET BORROWER LOANS
  // =========================================================

  Future<List<Loan>> getLoansByBorrower(int borrowerId) async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: "borrower_id=?",

      whereArgs: [borrowerId],

      orderBy: "id DESC",
    );

    return result.map((e) => Loan.fromMap(e)).toList();
  }

  // =========================================================
  // GET ACTIVE LOANS
  // =========================================================

  Future<List<Loan>> getActiveLoans() async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: "status=?",

      whereArgs: ["ACTIVE"],

      orderBy: "id DESC",
    );

    return result.map((e) => Loan.fromMap(e)).toList();
  }

  // =========================================================
  // GET COMPLETED LOANS
  // =========================================================

  Future<List<Loan>> getCompletedLoans() async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: "status=?",

      whereArgs: ["COMPLETED"],

      orderBy: "id DESC",
    );

    return result.map((e) => Loan.fromMap(e)).toList();
  }

  // =========================================================
  // GET CURRENT ACTIVE LOAN
  // =========================================================

  Future<Loan?> getCurrentLoan(int borrowerId) async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: """

      borrower_id=?

      AND status=?

      """,

      whereArgs: [borrowerId, "ACTIVE"],

      orderBy: "id DESC",

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Loan.fromMap(result.first);
  }

  // =========================================================
  // UPDATE LOAN BALANCE
  // =========================================================

  Future<void> updateBalance(int loanId, double balance) async {
    final database = await db;

    await database.update(
      "loans",

      {"remaining_balance": balance},

      where: "id=?",

      whereArgs: [loanId],
    );
  }

  // =========================================================
  // UPDATE LOAN STATUS
  // =========================================================

  Future<void> updateStatus(int loanId, String status) async {
    final database = await db;

    await database.update(
      "loans",

      {"status": status},

      where: "id=?",

      whereArgs: [loanId],
    );
  }

  // =========================================================
  // MARK LOAN AS COMPLETED
  // =========================================================

  Future<void> completeLoan(int loanId) async {
    final database = await db;

    await database.update(
      "loans",

      {"status": "COMPLETED", "remaining_balance": 0},

      where: "id=?",

      whereArgs: [loanId],
    );
  }

  // =========================================================
  // GET OUTSTANDING BALANCE
  // =========================================================

  Future<double> getOutstandingBalance(int borrowerId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

      SELECT 

      SUM(remaining_balance) AS balance

      FROM loans

      WHERE borrower_id=?

      AND status='ACTIVE'

      ''',

      [borrowerId],
    );

    return (result.first["balance"] as num?)?.toDouble() ?? 0.0;
  }

  // =========================================================
  // GET TOTAL BORROWED AMOUNT
  // =========================================================

  Future<double> getTotalBorrowed(int borrowerId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

      SELECT

      SUM(principal_amount) AS total

      FROM loans

      WHERE borrower_id=?

      ''',

      [borrowerId],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  // =========================================================
  // GET TOTAL PAYABLE
  // =========================================================

  Future<double> getTotalPayable(int borrowerId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

      SELECT

      SUM(total_payable) AS total

      FROM loans

      WHERE borrower_id=?

      ''',

      [borrowerId],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  // =========================================================
  // COUNT ACTIVE LOANS
  // =========================================================

  Future<int> getActiveLoanCount(int borrowerId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

      SELECT COUNT(*) AS count

      FROM loans

      WHERE borrower_id=?

      AND status='ACTIVE'

      ''',

      [borrowerId],
    );

    return (result.first["count"] as num).toInt();
  }

  // =========================================================
  // COUNT COMPLETED LOANS
  // =========================================================

  Future<int> getCompletedLoanCount(int borrowerId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

      SELECT COUNT(*) AS count

      FROM loans

      WHERE borrower_id=?

      AND status='COMPLETED'

      ''',

      [borrowerId],
    );

    return (result.first["count"] as num).toInt();
  }

  // =========================================================
  // SEARCH LOANS
  // =========================================================

  Future<List<Loan>> searchLoans(String query) async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: """

      loan_number LIKE ?

      """,

      whereArgs: ["%$query%"],

      orderBy: "id DESC",
    );

    return result.map((e) => Loan.fromMap(e)).toList();
  }

  // =========================================================
  // GET LOAN HISTORY
  // =========================================================

  Future<List<Loan>> getLoanHistory(int borrowerId) async {
    final database = await db;

    final result = await database.query(
      "loans",

      where: "borrower_id=?",

      whereArgs: [borrowerId],

      orderBy: "created_at DESC",
    );

    return result.map((e) => Loan.fromMap(e)).toList();
  }

  // =========================================================
  // TOTAL PORTFOLIO VALUE
  // =========================================================

  Future<double> getPortfolioValue() async {
    final database = await db;

    final result = await database.rawQuery('''

      SELECT

      SUM(principal_amount) AS total

      FROM loans

      WHERE status='ACTIVE'

      ''');

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  // =========================================================
  // TOTAL COLLECTIONS
  // =========================================================

  Future<double> getTotalCollections() async {
    final database = await db;

    final result = await database.rawQuery('''

      SELECT

      SUM(amount) AS total

      FROM loan_payments

      ''');

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  // =========================================================
  // ACTIVE LOAN COUNT SYSTEM WIDE
  // =========================================================

  Future<int> getSystemActiveLoans() async {
    final database = await db;

    final result = await database.rawQuery('''

      SELECT COUNT(*) AS count

      FROM loans

      WHERE status='ACTIVE'

      ''');

    return (result.first["count"] as num).toInt();
  }

  // =========================================================
  // OVERDUE LOANS
  // =========================================================

  Future<List<Loan>> getOverdueLoans() async {
    final database = await db;

    final today = DateTime.now().toIso8601String();

    final result = await database.query(
      "loans",

      where: """

      status='ACTIVE'

      AND end_date < ?

      """,

      whereArgs: [today],

      orderBy: "end_date ASC",
    );

    return result.map((e) => Loan.fromMap(e)).toList();
  }
}
