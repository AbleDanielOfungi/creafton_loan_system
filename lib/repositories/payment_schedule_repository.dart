// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import '../database/database_helper.dart';

// class PaymentScheduleRepository {

//   Future<void> createSchedule(
//     List<Map<String, dynamic>> schedule, {
//     DatabaseExecutor? database,
//   }) async {

//     final db =
//         database ?? await DatabaseHelper.database;

//     for (final payment in schedule) {

//       await db.insert(
//         "loan_payments",

//         payment,

//       );

//     }

//   }

// }

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';

import '../models/payment_schedule.dart';

class PaymentScheduleRepository {
  Future<Database> get db async {
    return await DatabaseHelper.database;
  }

  // =====================================================
  // CREATE PAYMENT SCHEDULE
  // =====================================================

  Future<void> createSchedule(
    List<Map<String, dynamic>> schedule, {
    DatabaseExecutor? database,
  }) async {
    final databaseInstance = database ?? await DatabaseHelper.database;

    for (final payment in schedule) {
      await databaseInstance.insert("loan_payments", payment);
    }
  }

  // =====================================================
  // GET LOAN SCHEDULE
  // =====================================================

  Future<List<PaymentSchedule>> getByLoan(int loanId) async {
    final database = await db;

    final result = await database.query(
      "loan_payments",

      where: "loan_id=?",

      whereArgs: [loanId],

      orderBy: "payment_number ASC",
    );

    return result.map((e) => PaymentSchedule.fromMap(e)).toList();
  }

  // =====================================================
  // GET NEXT PAYMENT
  // =====================================================

  Future<PaymentSchedule?> getNextPayment(int loanId) async {
    final database = await db;

    final result = await database.query(
      "loan_payments",

      where: """
loan_id=?
AND status='PENDING'
""",

      whereArgs: [loanId],

      orderBy: "payment_number ASC",

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return PaymentSchedule.fromMap(result.first);
  }

  // =====================================================
  // MARK PAYMENT AS PAID
  // =====================================================

  Future<void> markPaid(int paymentId, {required String paymentDate}) async {
    final database = await db;

    await database.update(
      "loan_payments",

      {"status": "PAID", "payment_date": paymentDate},

      where: "id=?",

      whereArgs: [paymentId],
    );
  }

  // =====================================================
  // COUNT STATUS
  // =====================================================

  Future<int> countPending(int loanId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

SELECT COUNT(*) count

FROM loan_payments

WHERE loan_id=?

AND status='PENDING'

''',
      [loanId],
    );

    return (result.first["count"] as num).toInt();
  }

  Future<int> countPaid(int loanId) async {
    final database = await db;

    final result = await database.rawQuery(
      '''

SELECT COUNT(*) count

FROM loan_payments

WHERE loan_id=?

AND status='PAID'

''',
      [loanId],
    );

    return (result.first["count"] as num).toInt();
  }
}
