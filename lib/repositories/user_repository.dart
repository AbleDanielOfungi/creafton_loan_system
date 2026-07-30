// import 'package:creafton_financial_services/database/database_helper.dart';
// import 'package:creafton_financial_services/models/user_model.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';



// class UsernameTakenException implements Exception {
//   final String username;
//   UsernameTakenException(this.username);

//   @override
//   String toString() => "Username \"$username\" is already taken";
// }

// class UserRepository {
//   // =====================================================
//   // ALL USERS (joined with role name)
//   // =====================================================

//   Future<List<User>> getAll() async {
//     final db = await DatabaseHelper.database;

//     final result = await db.rawQuery("""
//       SELECT users.*, roles.name AS role_name
//       FROM users
//       LEFT JOIN roles ON roles.id = users.role_id
//       ORDER BY users.full_name ASC
//     """);

//     return result.map((e) => User.fromMap(e)).toList();
//   }

//   // =====================================================
//   // SEARCH USERS BY NAME / USERNAME / PHONE
//   // =====================================================

//   Future<List<User>> search(String query) async {
//     final db = await DatabaseHelper.database;

//     final like = "%$query%";

//     final result = await db.rawQuery(
//       """
//       SELECT users.*, roles.name AS role_name
//       FROM users
//       LEFT JOIN roles ON roles.id = users.role_id
//       WHERE users.full_name LIKE ?
//          OR users.username LIKE ?
//          OR users.phone LIKE ?
//       ORDER BY users.full_name ASC
//       """,
//       [like, like, like],
//     );

//     return result.map((e) => User.fromMap(e)).toList();
//   }

//   // =====================================================
//   // GET BY ID
//   // =====================================================

//   Future<User?> getById(int id) async {
//     final db = await DatabaseHelper.database;

//     final result = await db.rawQuery(
//       """
//       SELECT users.*, roles.name AS role_name
//       FROM users
//       LEFT JOIN roles ON roles.id = users.role_id
//       WHERE users.id = ?
//       LIMIT 1
//       """,
//       [id],
//     );

//     if (result.isEmpty) return null;

//     return User.fromMap(result.first);
//   }

//   // =====================================================
//   // ALL ROLES (for the role dropdown)
//   // =====================================================

//   Future<List<UserRole>> getRoles() async {
//     final db = await DatabaseHelper.database;

//     final result = await db.query("roles", orderBy: "name ASC");

//     return result.map((e) => UserRole.fromMap(e)).toList();
//   }

//   // =====================================================
//   // CREATE USER
//   // =====================================================

//   Future<int> create(User user) async {
//     final db = await DatabaseHelper.database;

//     if (await _usernameExists(user.username)) {
//       throw UsernameTakenException(user.username);
//     }

//     final map = user.toMap()..remove("id");

//     try {
//       return await db.insert(
//         "users",
//         map,
//         conflictAlgorithm: ConflictAlgorithm.abort,
//       );
//     } on DatabaseException catch (e) {
//       if (e.isUniqueConstraintError()) {
//         throw UsernameTakenException(user.username);
//       }
//       rethrow;
//     }
//   }

//   // =====================================================
//   // UPDATE USER
//   // =====================================================
//   //
//   // If `user.password` is empty, the existing password is left untouched
//   // (so editing a user doesn't force resetting their password every time).

//   Future<void> update(User user) async {
//     if (user.id == null) {
//       throw ArgumentError("Cannot update a user without an id");
//     }

//     final db = await DatabaseHelper.database;

//     if (await _usernameExists(user.username, excludeId: user.id)) {
//       throw UsernameTakenException(user.username);
//     }

//     final map = user.toMap()..remove("id");
//     map.remove("created_at");

//     if (user.password.trim().isEmpty) {
//       map.remove("password");
//     }

//     try {
//       await db.update(
//         "users",
//         map,
//         where: "id=?",
//         whereArgs: [user.id],
//       );
//     } on DatabaseException catch (e) {
//       if (e.isUniqueConstraintError()) {
//         throw UsernameTakenException(user.username);
//       }
//       rethrow;
//     }
//   }

//   // =====================================================
//   // TOGGLE ACTIVE / DISABLED
//   // =====================================================

//   Future<void> setStatus(int id, int status) async {
//     final db = await DatabaseHelper.database;

//     await db.update(
//       "users",
//       {"status": status},
//       where: "id=?",
//       whereArgs: [id],
//     );
//   }

//   // =====================================================
//   // DELETE USER
//   // =====================================================

//   Future<void> delete(int id) async {
//     final db = await DatabaseHelper.database;

//     await db.delete("users", where: "id=?", whereArgs: [id]);
//   }

//   // =====================================================
//   // HELPERS
//   // =====================================================

//   Future<bool> _usernameExists(String username, {int? excludeId}) async {
//     final db = await DatabaseHelper.database;

//     final result = excludeId == null
//         ? await db.query(
//             "users",
//             where: "username=?",
//             whereArgs: [username],
//             limit: 1,
//           )
//         : await db.query(
//             "users",
//             where: "username=? AND id != ?",
//             whereArgs: [username, excludeId],
//             limit: 1,
//           );

//     return result.isNotEmpty;
//   }
// }



import 'package:creafton_financial_services/database/database_helper.dart';
import 'package:creafton_financial_services/models/user_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../screens/auth/password_helper.dart';

class UsernameTakenException implements Exception {
  final String username;
  UsernameTakenException(this.username);

  @override
  String toString() => "Username \"$username\" is already taken";
}

class UserRepository {
  // =====================================================
  // ALL USERS (joined with role name)
  // =====================================================

  Future<List<User>> getAll() async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery("""
      SELECT users.*, roles.name AS role_name
      FROM users
      LEFT JOIN roles ON roles.id = users.role_id
      ORDER BY users.full_name ASC
    """);

    return result.map((e) => User.fromMap(e)).toList();
  }

  // =====================================================
  // SEARCH USERS BY NAME / USERNAME / PHONE
  // =====================================================

  Future<List<User>> search(String query) async {
    final db = await DatabaseHelper.database;

    final like = "%$query%";

    final result = await db.rawQuery(
      """
      SELECT users.*, roles.name AS role_name
      FROM users
      LEFT JOIN roles ON roles.id = users.role_id
      WHERE users.full_name LIKE ?
         OR users.username LIKE ?
         OR users.phone LIKE ?
      ORDER BY users.full_name ASC
      """,
      [like, like, like],
    );

    return result.map((e) => User.fromMap(e)).toList();
  }

  // =====================================================
  // GET BY ID
  // =====================================================

  Future<User?> getById(int id) async {
    final db = await DatabaseHelper.database;

    final result = await db.rawQuery(
      """
      SELECT users.*, roles.name AS role_name
      FROM users
      LEFT JOIN roles ON roles.id = users.role_id
      WHERE users.id = ?
      LIMIT 1
      """,
      [id],
    );

    if (result.isEmpty) return null;

    return User.fromMap(result.first);
  }

  // =====================================================
  // ALL ROLES (for the role dropdown)
  // =====================================================

  Future<List<UserRole>> getRoles() async {
    final db = await DatabaseHelper.database;

    final result = await db.query("roles", orderBy: "name ASC");

    return result.map((e) => UserRole.fromMap(e)).toList();
  }

  // =====================================================
  // CREATE USER
  // =====================================================

  Future<int> create(User user) async {
    final db = await DatabaseHelper.database;

    if (await _usernameExists(user.username)) {
      throw UsernameTakenException(user.username);
    }

    final map = user.toMap()..remove("id");

    // Store the hash, never the raw password — AuthService.login() compares
    // against PasswordHelper.hashPassword(input), so this must match exactly.
    map["password"] = PasswordHelper.hashPassword(user.password);

    try {
      return await db.insert(
        "users",
        map,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw UsernameTakenException(user.username);
      }
      rethrow;
    }
  }

  // =====================================================
  // UPDATE USER
  // =====================================================
  //
  // If `user.password` is empty, the existing password is left untouched
  // (so editing a user doesn't force resetting their password every time).

  Future<void> update(User user) async {
    if (user.id == null) {
      throw ArgumentError("Cannot update a user without an id");
    }

    final db = await DatabaseHelper.database;

    if (await _usernameExists(user.username, excludeId: user.id)) {
      throw UsernameTakenException(user.username);
    }

    final map = user.toMap()..remove("id");
    map.remove("created_at");

    if (user.password.trim().isEmpty) {
      // No new password entered — leave the existing hash untouched.
      map.remove("password");
    } else {
      map["password"] = PasswordHelper.hashPassword(user.password);
    }

    try {
      await db.update(
        "users",
        map,
        where: "id=?",
        whereArgs: [user.id],
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw UsernameTakenException(user.username);
      }
      rethrow;
    }
  }

  // =====================================================
  // TOGGLE ACTIVE / DISABLED
  // =====================================================

  Future<void> setStatus(int id, int status) async {
    final db = await DatabaseHelper.database;

    await db.update(
      "users",
      {"status": status},
      where: "id=?",
      whereArgs: [id],
    );
  }

  // =====================================================
  // DELETE USER
  // =====================================================

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.database;

    await db.delete("users", where: "id=?", whereArgs: [id]);
  }

  // =====================================================
  // HELPERS
  // =====================================================

  Future<bool> _usernameExists(String username, {int? excludeId}) async {
    final db = await DatabaseHelper.database;

    final result = excludeId == null
        ? await db.query(
            "users",
            where: "username=?",
            whereArgs: [username],
            limit: 1,
          )
        : await db.query(
            "users",
            where: "username=? AND id != ?",
            whereArgs: [username, excludeId],
            limit: 1,
          );

    return result.isNotEmpty;
  }
}