// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import '../database/database_helper.dart';
// import '../models/guarantor.dart';

// class GuarantorRepository {
//   Future<Database> get _database async => await DatabaseHelper.database;

//   // =====================================================
//   // INSERT GUARANTOR
//   // =====================================================

//   Future<int> insert(Guarantor guarantor) async {
//     final db = await _database;

//     return await db.insert(
//       'guarantors',

//       guarantor.toMap()..remove('id'),

//       conflictAlgorithm: ConflictAlgorithm.abort,
//     );
//   }

//   // =====================================================
//   // UPDATE GUARANTOR
//   // =====================================================

//   Future<int> update(Guarantor guarantor) async {
//     final db = await _database;

//     return await db.update(
//       'guarantors',

//       guarantor.toMap()..remove('id'),

//       where: 'id = ?',

//       whereArgs: [guarantor.id],
//     );
//   }

//   // =====================================================
//   // GET GUARANTORS BY BORROWER
//   // =====================================================

//   Future<List<Guarantor>> getByBorrower(int borrowerId) async {
//     final db = await _database;

//     final result = await db.query(
//       'guarantors',

//       where: 'borrower_id = ?',

//       whereArgs: [borrowerId],

//       orderBy: 'id DESC',
//     );

//     return result.map((row) => Guarantor.fromMap(row)).toList();
//   }

//   // =====================================================
//   // GET SINGLE GUARANTOR
//   // =====================================================

//   Future<Guarantor?> getById(int id) async {
//     final db = await _database;

//     final result = await db.query(
//       'guarantors',

//       where: 'id = ?',

//       whereArgs: [id],
//     );

//     if (result.isEmpty) {
//       return null;
//     }

//     return Guarantor.fromMap(result.first);
//   }

//   // =====================================================
//   // DELETE GUARANTOR
//   // =====================================================

//   Future<int> delete(int id) async {
//     final db = await _database;

//     return await db.delete('guarantors', where: 'id = ?', whereArgs: [id]);
//   }

//   // =====================================================
//   // COUNT GUARANTORS
//   // =====================================================

//   Future<int> count(int borrowerId) async {
//     final db = await _database;

//     final result = await db.rawQuery(
//       '''
//       SELECT COUNT(*) as total
//       FROM guarantors
//       WHERE borrower_id = ?
//       ''',

//       [borrowerId],
//     );

//     return result.first['total'] as int;
//   }
// }



import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';
import '../models/guarantor.dart';

class GuarantorRepository {


  Future<Database> get _database async =>
      await DatabaseHelper.database;



  // =====================================================
  // INSERT GUARANTOR
  // =====================================================

  Future<int> insert(Guarantor guarantor) async {

    final db = await _database;


    return await db.insert(

      'guarantors',

      guarantor.toMap()..remove('id'),

      conflictAlgorithm:
      ConflictAlgorithm.abort,

    );

  }







  // =====================================================
  // UPDATE GUARANTOR
  // =====================================================

  Future<int> update(Guarantor guarantor) async {

    final db = await _database;


    return await db.update(

      'guarantors',

      guarantor.toMap()..remove('id'),

      where: 'id = ?',

      whereArgs: [
        guarantor.id
      ],

    );

  }








  // =====================================================
  // GET GUARANTORS BY BORROWER
  // =====================================================

  Future<List<Guarantor>> getByBorrower(
      int borrowerId
      ) async {

    final db = await _database;


    final result = await db.query(

      'guarantors',

      where: 'borrower_id = ?',

      whereArgs: [
        borrowerId
      ],

      orderBy: 'id DESC',

    );


    return result
        .map(
          (row)=>Guarantor.fromMap(row),
        )
        .toList();

  }









  // =====================================================
  // GET ALL GUARANTORS
  // Used by Global Guarantors Module
  // =====================================================

  Future<List<Guarantor>> getAll() async {


    final db = await _database;



    final result = await db.query(

      'guarantors',

      orderBy: 'id DESC',

    );



    return result
        .map(
          (row)=>Guarantor.fromMap(row),
        )
        .toList();


  }









  // =====================================================
  // SEARCH GUARANTORS
  // =====================================================

  Future<List<Guarantor>> search(
      String keyword
      ) async {


    final db = await _database;



    final result = await db.query(

      'guarantors',

      where:
      '''
      full_name LIKE ?
      OR phone LIKE ?
      OR national_id LIKE ?
      OR relationship LIKE ?
      ''',


      whereArgs: [

        "%$keyword%",

        "%$keyword%",

        "%$keyword%",

        "%$keyword%",

      ],


      orderBy:
      'id DESC',

    );




    return result
        .map(
          (row)=>Guarantor.fromMap(row),
        )
        .toList();


  }









  // =====================================================
  // GET SINGLE GUARANTOR
  // =====================================================

  Future<Guarantor?> getById(
      int id
      ) async {


    final db = await _database;



    final result = await db.query(

      'guarantors',

      where: 'id = ?',

      whereArgs: [
        id
      ],

    );



    if(result.isEmpty){

      return null;

    }



    return Guarantor.fromMap(
        result.first
    );


  }









  // =====================================================
  // DELETE GUARANTOR
  // =====================================================

  Future<int> delete(
      int id
      ) async {


    final db = await _database;


    return await db.delete(

      'guarantors',

      where: 'id = ?',

      whereArgs: [
        id
      ],

    );


  }









  // =====================================================
  // COUNT GUARANTORS
  // =====================================================

  Future<int> count(
      int borrowerId
      ) async {


    final db = await _database;



    final result =
    await db.rawQuery(

      '''
      SELECT COUNT(*) as total
      FROM guarantors
      WHERE borrower_id = ?
      ''',

      [
        borrowerId
      ],

    );



    return result.first['total'] as int;


  }


}