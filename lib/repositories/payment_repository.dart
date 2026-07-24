import 'package:creafton_financial_services/database/database_helper.dart';

import '../models/loan_payment.dart';

class PaymentRepository {
  // =====================================================
  // CREATE PAYMENT + UPDATE LOAN BALANCE
  // =====================================================

  Future<int> create(LoanPayment payment) async {
    final db = await DatabaseHelper.database;

    int paymentId = 0;

    await db.transaction((txn) async {
      // Insert payment

      paymentId = await txn.insert("loan_payments", payment.toMap());

      // Get current loan balance

      final loanResult = await txn.query(
        "loans",

        columns: ["remaining_balance"],

        where: "id=?",

        whereArgs: [payment.loanId],

        limit: 1,
      );

      if (loanResult.isEmpty) {
        throw Exception("Loan not found");
      }

      double currentBalance = (loanResult.first["remaining_balance"] as num)
          .toDouble();

      double newBalance = currentBalance - payment.amount;

      if (newBalance < 0) {
        newBalance = 0;
      }

      // Update loan balance

      await txn.update(
        "loans",

        {
          "remaining_balance": newBalance,

          "status": newBalance == 0 ? "COMPLETED" : "ACTIVE",
        },

        where: "id=?",

        whereArgs: [payment.loanId],
      );
    });

    return paymentId;
  }

  // =====================================================
  // ALL PAYMENTS
  // =====================================================

  Future<List<LoanPayment>> getAll() async {
    final db = await DatabaseHelper.database;

    final result = await db.query("loan_payments", orderBy: "id DESC");

    return result.map((e) => LoanPayment.fromMap(e)).toList();
  }

  // =====================================================
  // RECENT PAYMENTS BY BORROWER
  // =====================================================

  Future<List<LoanPayment>> recentPayments(int borrowerId) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      """

SELECT loan_payments.*

FROM loan_payments


INNER JOIN loans

ON loan_payments.loan_id = loans.id



WHERE loans.borrower_id = ?



ORDER BY loan_payments.id DESC



LIMIT 10


""",

      [borrowerId],
    );

    return result.map((e) => LoanPayment.fromMap(e)).toList();
  }

  // =====================================================
  // PAYMENT COUNT BY BORROWER
  // =====================================================

  Future<int> paymentCount(int borrowerId) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      """

SELECT COUNT(*) AS count


FROM loan_payments


INNER JOIN loans


ON loan_payments.loan_id = loans.id



WHERE loans.borrower_id = ?


""",

      [borrowerId],
    );

    return ((result.first["count"] ?? 0) as num).toInt();
  }

  // =====================================================
  // MONTHLY COLLECTION
  // =====================================================

  Future<double> monthlyCollection() async {
    final db = await DatabaseHelper.database;

    final now = DateTime.now();

    final month = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    final result = await db.rawQuery(
      """

SELECT SUM(amount) AS total


FROM loan_payments



WHERE payment_date LIKE ?


""",

      ["$month%"],
    );

    return ((result.first["total"] ?? 0) as num).toDouble();
  }

  // =====================================================
  // PAYMENTS BY LOAN
  // =====================================================

  Future<List<LoanPayment>> getPaymentsByLoan(int loanId) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "loan_payments",

      where: "loan_id=?",

      whereArgs: [loanId],

      orderBy: "id DESC",
    );

    return result.map((e) => LoanPayment.fromMap(e)).toList();
  }

  // =====================================================
  // PAYMENTS BY BORROWER
  // =====================================================

  Future<List<LoanPayment>> getPaymentsByBorrower(int borrowerId) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      """

SELECT loan_payments.*

FROM loan_payments

INNER JOIN loans

ON loan_payments.loan_id = loans.id


WHERE loans.borrower_id = ?


ORDER BY loan_payments.id DESC

""",

      [borrowerId],
    );

    return result.map((e) => LoanPayment.fromMap(e)).toList();
  }

  // =====================================================
  // TOTAL PAID FOR LOAN
  // =====================================================

  Future<double> getLoanTotalPaid(int loanId) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      """

SELECT SUM(amount) total

FROM loan_payments

WHERE loan_id=?

""",

      [loanId],
    );

    return ((result.first["total"] ?? 0) as num).toDouble();
  }

  // =====================================================
  // TOTAL PAID BY BORROWER
  // =====================================================

  Future<double> getTotalPaid(int borrowerId) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      """

SELECT SUM(loan_payments.amount) total


FROM loan_payments


INNER JOIN loans


ON loan_payments.loan_id =
loans.id


WHERE loans.borrower_id=?


""",

      [borrowerId],
    );

    return ((result.first["total"] ?? 0) as num).toDouble();
  }

  // =====================================================
  // TODAY COLLECTION
  // =====================================================

  Future<double> todayCollection() async {
    final db = await DatabaseHelper.database;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final result = await db.rawQuery(
      """

SELECT SUM(amount) total

FROM loan_payments

WHERE DATE(payment_date)=?


""",

      [today],
    );

    return ((result.first["total"] ?? 0) as num).toDouble();
  }

  // =====================================================
  // DELETE PAYMENT
  // =====================================================

  Future<void> delete(int paymentId) async {
    final db = await DatabaseHelper.database;

    await db.delete("loan_payments", where: "id=?", whereArgs: [paymentId]);
  }

  Future<List<LoanPayment>> getLoanPayments(int loanId) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "loan_payments",

      where: "loan_id=?",

      whereArgs: [loanId],

      orderBy: "payment_number ASC",
    );

    return result.map((e) => LoanPayment.fromMap(e)).toList();
  }

  Future<Map<String, dynamic>> getLoanPaymentStatistics(int loanId) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      '''

SELECT

COUNT(*) totalPayments,


SUM(
CASE 
WHEN status='PAID'
THEN 1
ELSE 0
END
) completedPayments,


SUM(
CASE
WHEN status='PENDING'
THEN 1
ELSE 0
END
) pendingPayments,


SUM(amount) totalPaid


FROM loan_payments


WHERE loan_id=?

''',

      [loanId],
    );

    return result.first;
  }
}
