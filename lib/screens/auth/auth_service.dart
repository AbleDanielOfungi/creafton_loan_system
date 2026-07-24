import 'package:creafton_financial_services/database/database_helper.dart';

import 'password_helper.dart';

import 'session_manager.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    final db = await DatabaseHelper.database;

    final result = await db.query(
      "users",

      where: "username = ?",

      whereArgs: [username],
    );

    if (result.isEmpty) {
      return false;
    }

    final user = result.first;

    bool valid = PasswordHelper.verifyPassword(
      password,

      user["password"] as String,
    );

    if (valid) {
      await SessionManager.saveSession(
        userId: user["id"] as int,

        username: user["username"] as String,

        role: user["role_id"].toString(),
      );

      return true;
    }

    return false;
  }
}
