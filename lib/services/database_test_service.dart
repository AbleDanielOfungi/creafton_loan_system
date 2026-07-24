import '../database/database_helper.dart';

class DatabaseTestService {
  static Future<void> test() async {
    final db = await DatabaseHelper.database;

    var result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );

    print(result);
  }
}
