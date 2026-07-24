import 'package:creafton_financial_services/database/database_helper.dart';

import '../screens/borrowers/borrower.dart';

class BorrowerProfileRepository {
  /// Get borrower basic profile information
  Future<Borrower?> getBorrowerProfile(int id) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "borrowers",

      where: "id = ?",

      whereArgs: [id],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Borrower.fromMap(result.first);
  }

  /// Get borrower loans
  Future<List<Map<String, dynamic>>> getBorrowerLoans(int borrowerId) async {
    final db = await DatabaseHelper.database;

    return await db.query(
      "loans",

      where: "borrower_id = ?",

      whereArgs: [borrowerId],

      orderBy: "id DESC",
    );
  }

  /// Get borrower payment history
  Future<List<Map<String, dynamic>>> getBorrowerPayments(int borrowerId) async {
    final db = await DatabaseHelper.database;

    return await db.rawQuery(
      """

SELECT 

loan_payments.*,

loans.loan_number


FROM loan_payments


INNER JOIN loans

ON loan_payments.loan_id = loans.id


WHERE loans.borrower_id = ?


ORDER BY loan_payments.id DESC


""",

      [borrowerId],
    );
  }

  /// Get borrower guarantors
  Future<List<Map<String, dynamic>>> getBorrowerGuarantors(
    int borrowerId,
  ) async {
    final db = await DatabaseHelper.database;

    return await db.query(
      "guarantors",

      where: "borrower_id = ?",

      whereArgs: [borrowerId],

      orderBy: "id DESC",
    );
  }

  /// Get borrower uploaded documents
  Future<List<Map<String, dynamic>>> getBorrowerDocuments(
    int borrowerId,
  ) async {
    final db = await DatabaseHelper.database;

    return await db.query(
      "borrower_documents",

      where: "borrower_id = ?",

      whereArgs: [borrowerId],

      orderBy: "id DESC",
    );
  }

  /// Get assigned field officer
  Future<Map<String, dynamic>?> getFieldOfficer(int? officerId) async {
    if (officerId == null) {
      return null;
    }

    final db = await DatabaseHelper.database;

    final result = await db.query(
      "field_officers",

      where: "id = ?",

      whereArgs: [officerId],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  /// Get borrower performance statistics

  Future<Map<String, dynamic>?> getBorrowerPerformance(int borrowerId) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "borrower_performance",

      where: "borrower_id = ?",

      whereArgs: [borrowerId],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }
}
