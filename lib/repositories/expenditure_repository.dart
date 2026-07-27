import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';
import '../models/expenditure.dart';


class ExpenditureRepository {


  Future<Database> get database async =>
      await DatabaseHelper.database;



  // =====================================================
  // GET ALL EXPENDITURES
  // =====================================================

  Future<List<Expenditure>> getAll() async {


    final db =
        await database;


    final result =
        await db.query(

          'expenditures',

          orderBy:
          'id DESC',

        );


    return result
        .map(
          (row)=>
              Expenditure.fromMap(row),
    )
        .toList();


  }


  Future<List<Map<String,dynamic>>> getByCategory() async {


final db =
await DatabaseHelper.database;



return await db.rawQuery(

'''
SELECT

category_id,

SUM(amount) as total,

COUNT(id) as transactions


FROM expenditures


GROUP BY category_id


ORDER BY total DESC

'''

);


}


  Future<List<Map<String,dynamic>>> getByDateRange(
    String start,
    String end
) async {


final db = await DatabaseHelper.database;


return await db.query(

'expenditures',

where:
'''
expense_date BETWEEN ? AND ?
''',

whereArgs:[
start,
end
],

orderBy:
'expense_date DESC',

);


}






  // =====================================================
  // INSERT
  // =====================================================

  Future<int> insert(
      Expenditure expenditure
      ) async {


    final db =
        await database;


    return await db.insert(

      'expenditures',

      expenditure.toMap()
        ..remove('id'),

      conflictAlgorithm:
      ConflictAlgorithm.abort,

    );


  }








  // =====================================================
  // UPDATE
  // =====================================================

  Future<int> update(
      Expenditure expenditure
      ) async {


    final db =
        await database;



    return await db.update(

      'expenditures',

      expenditure.toMap()
        ..remove('id'),


      where:
      'id=?',


      whereArgs:[
        expenditure.id
      ],

    );


  }








  // =====================================================
  // DELETE
  // =====================================================

  Future<int> delete(
      int id
      ) async {


    final db =
        await database;



    return await db.delete(

      'expenditures',

      where:
      'id=?',

      whereArgs:[
        id
      ],

    );


  }



}