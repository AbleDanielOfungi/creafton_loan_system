import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../database/database_helper.dart';
import '../models/expenditure_category.dart';

class ExpenditureCategoryRepository {
  Future<Database> get database async => await DatabaseHelper.database;

  Future<List<ExpenditureCategory>> getAll() async {
    final db = await database;

    final result = await db.query('expenditure_categories', orderBy: 'id DESC');

    return result.map((e) => ExpenditureCategory.fromMap(e)).toList();
  }

  Future<int> insert(ExpenditureCategory category) async {
    final db = await database;

    return await db.insert(
      'expenditure_categories',

      category.toMap()..remove('id'),

      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> update(ExpenditureCategory category) async {
    final db = await database;

    return await db.update(
      'expenditure_categories',

      category.toMap()..remove('id'),

      where: 'id=?',

      whereArgs: [category.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      'expenditure_categories',

      where: 'id=?',

      whereArgs: [id],
    );
  }
}
