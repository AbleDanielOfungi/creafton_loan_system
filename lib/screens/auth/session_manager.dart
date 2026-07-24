import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String userIdKey = "user_id";

  static const String usernameKey = "username";

  static const String roleKey = "role";

  static Future<void> saveSession({
    required int userId,

    required String username,

    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(userIdKey, userId);

    await prefs.setString(usernameKey, username);

    await prefs.setString(roleKey, role);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(userIdKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(roleKey);
  }
}
