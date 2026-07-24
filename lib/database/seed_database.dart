import 'package:creafton_financial_services/screens/auth/password_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_helper.dart';

class DatabaseSeed {
  static Future<void> seed() async {
    final db = await DatabaseHelper.database;

    await db.insert("roles", {
      "name": "Administrator",
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.insert("roles", {
      "name": "Cashier",
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    var admin = await db.query(
      "users",

      where: "username=?",

      whereArgs: ["admin"],
    );

    if (admin.isEmpty) {
      await db.insert("users", {
        "username": "admin",

        "password": PasswordHelper.hashPassword("admin123"),

        "full_name": "System Administrator",

        "role_id": 1,

        "status": 1,

        "created_at": DateTime.now().toIso8601String(),
      });
    }
  }
}
