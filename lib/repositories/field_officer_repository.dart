import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';
import '../models/field_officer.dart';



class FieldOfficerRepository {


  Future<Database> get _db async =>
      await DatabaseHelper.database;




  // =====================================================
  // INSERT FIELD OFFICER
  // =====================================================

  Future<int> insert(
      FieldOfficer officer) async {


    final db = await _db;


    return await db.insert(

      'field_officers',

      officer.toMap()
        ..remove('id'),

      conflictAlgorithm:
      ConflictAlgorithm.abort,

    );


  }






  // =====================================================
  // UPDATE FIELD OFFICER
  // =====================================================

  Future<int> update(
      FieldOfficer officer) async {


    final db = await _db;


    return await db.update(

      'field_officers',

      officer.toMap()
        ..remove('id'),

      where:
      'id = ?',


      whereArgs:
      [
        officer.id
      ],

    );


  }







  // =====================================================
  // GET ALL FIELD OFFICERS
  // =====================================================

  Future<List<FieldOfficer>>
  getAll() async {


    final db = await _db;


    final result =
    await db.query(

      'field_officers',

      orderBy:
      'id DESC',

    );



    return result
        .map(
            (e)=>FieldOfficer.fromMap(e)
    )
        .toList();


  }







  // =====================================================
  // GET ACTIVE OFFICERS
  // =====================================================

  Future<List<FieldOfficer>>
  getActive() async {


    final db =
    await _db;



    final result =
    await db.query(

      'field_officers',


      where:
      'status = ?',


      whereArgs:
      [
        'ACTIVE'
      ],

      orderBy:
      'full_name ASC',

    );



    return result
        .map(
            (e)=>FieldOfficer.fromMap(e)
    )
        .toList();


  }







  // =====================================================
  // GET BY ID
  // =====================================================

  Future<FieldOfficer?>
  getById(int id) async {


    final db =
    await _db;



    final result =
    await db.query(

      'field_officers',

      where:
      'id = ?',


      whereArgs:
      [
        id
      ],

    );



    if(result.isEmpty){

      return null;

    }


    return FieldOfficer.fromMap(
        result.first
    );


  }







  // =====================================================
  // SEARCH OFFICER
  // =====================================================

  Future<List<FieldOfficer>>
  search(String keyword) async {


    final db =
    await _db;



    final result =
    await db.query(

      'field_officers',


      where:
      '''
      full_name LIKE ?
      OR phone LIKE ?
      OR officer_number LIKE ?
      OR national_id LIKE ?
      ''',



      whereArgs:
      [

        '%$keyword%',

        '%$keyword%',

        '%$keyword%',

        '%$keyword%',

      ],


    );



    return result
        .map(
            (e)=>FieldOfficer.fromMap(e)
    )
        .toList();



  }







  // =====================================================
  // UPDATE STATUS
  // =====================================================

  Future<int> updateStatus(
      int id,
      String status) async {


    final db =
    await _db;



    return await db.update(

      'field_officers',

      {

        'status':
        status

      },


      where:
      'id = ?',


      whereArgs:
      [
        id
      ],

    );


  }








  // =====================================================
  // COUNT OFFICERS
  // =====================================================

  Future<int> count() async {


    final db =
    await _db;



    final result =
    await db.rawQuery(

      '''
      SELECT COUNT(*) as total
      FROM field_officers
      '''

    );


    return result.first['total'] as int;


  }








  // =====================================================
  // ASSIGN BORROWER
  // =====================================================

  Future<int> assignBorrower(

      int borrowerId,

      int officerId

      ) async {



    final db =
    await _db;



    return await db.update(

      'borrowers',


      {

        'field_officer_id':
        officerId

      },


      where:
      'id = ?',


      whereArgs:
      [
        borrowerId
      ],

    );


  }








  // =====================================================
  // REMOVE BORROWER ASSIGNMENT
  // =====================================================

  Future<int> removeBorrower(
      int borrowerId) async {


    final db =
    await _db;



    return await db.update(

      'borrowers',


      {

        'field_officer_id':
        null

      },


      where:
      'id = ?',


      whereArgs:
      [
        borrowerId
      ],


    );


  }








  // =====================================================
  // GET PERFORMANCE
  // =====================================================

  Future<Map<String,dynamic>>
  getPerformance(
      int officerId) async {



    final db =
    await _db;



    final result =
    await db.query(

      'field_officer_performance',


      where:
      'field_officer_id = ?',


      whereArgs:
      [
        officerId
      ],


    );




    if(result.isNotEmpty){

      return result.first;

    }




    return {


      'total_assigned':
      0,


      'active_loans':
      0,


      'completed_loans':
      0,


      'total_collected':
      0,


      'recovery_rate':
      0,


    };


  }







  // =====================================================
  // CREATE PERFORMANCE RECORD
  // =====================================================

  Future<void>
  initializePerformance(
      int officerId) async {


    final db =
    await _db;



    await db.insert(

      'field_officer_performance',

      {


        'field_officer_id':
        officerId,


        'last_updated':
        DateTime.now()
            .toIso8601String()


      },


      conflictAlgorithm:
      ConflictAlgorithm.ignore,

    );


  }


}