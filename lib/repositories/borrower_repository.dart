
import 'package:creafton_financial_services/screens/borrowers/borrower.dart';

import '../database/database_helper.dart';

class BorrowerRepository {
  // =====================================================
  // CREATE
  // =====================================================

  Future<int> create(Borrower borrower) async {
    final db = await DatabaseHelper.database;

    return await db.insert("borrowers", borrower.toMap());
  }

  // =====================================================
  // GET ALL
  // =====================================================

  Future<List<Borrower>> getAll() async {
    final db = await DatabaseHelper.database;

    final result = await db.query("borrowers", orderBy: "id DESC");

    return result.map((e) => Borrower.fromMap(e)).toList();
  }

  // =====================================================
  // GET BY ID
  // =====================================================

  Future<Borrower?> getById(int id) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "borrowers",
      where: "id=?",
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Borrower.fromMap(result.first);
  }

  // =====================================================
  // SEARCH
  // =====================================================

  Future<List<Borrower>> search(String keyword) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "borrowers",
      where: '''

full_name LIKE ?
OR phone LIKE ?
OR borrower_number LIKE ?
OR national_id LIKE ?

''',
      whereArgs: ["%$keyword%", "%$keyword%", "%$keyword%", "%$keyword%"],
      orderBy: "id DESC",
    );

    return result.map((e) => Borrower.fromMap(e)).toList();
  }

  // =====================================================
  // UPDATE
  // =====================================================

  Future<int> update(Borrower borrower) async {
    final db = await DatabaseHelper.database;

    return await db.update(
      "borrowers",
      borrower.toMap(),
      where: "id=?",
      whereArgs: [borrower.id],
    );
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.database;

    await db.delete("borrowers", where: "id=?", whereArgs: [id]);
  }

  // =====================================================
// SEARCH BORROWERS
// =====================================================

Future<List<Borrower>> searchBorrowers(String keyword) async {

  final db = await DatabaseHelper.database;


  final result = await db.query(
    'borrowers',

    where: '''
    full_name LIKE ?
    OR borrower_number LIKE ?
    OR phone LIKE ?
    OR national_id LIKE ?
    ''',

    whereArgs: [

      "%$keyword%",

      "%$keyword%",

      "%$keyword%",

      "%$keyword%",

    ],

    orderBy: 'id DESC',
  );


  return result
      .map(
        (row)=>Borrower.fromMap(row),
      )
      .toList();

}
}
