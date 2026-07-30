import 'package:creafton_financial_services/models/user_model.dart';
import 'package:creafton_financial_services/repositories/user_repository.dart';
import 'package:flutter/material.dart';



class UserProvider extends ChangeNotifier {
  final UserRepository repository = UserRepository();

  List<User> users = [];
  List<UserRole> roles = [];

  bool loading = false;
  bool savingUser = false;

  String? error;

  // =====================================================
  // LOAD USERS + ROLES
  // =====================================================

  Future<void> loadUsers() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      users = await repository.getAll();

      if (roles.isEmpty) {
        roles = await repository.getRoles();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // SEARCH
  // =====================================================

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      await loadUsers();
      return;
    }

    loading = true;
    error = null;
    notifyListeners();

    try {
      users = await repository.search(query.trim());
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // CREATE USER
  // =====================================================

  Future<bool> createUser(User user) async {
    savingUser = true;
    error = null;
    notifyListeners();

    try {
      await repository.create(user);
      await loadUsers();
      return true;
    } catch (e) {
      error = _friendlyError(e);
      notifyListeners();
      return false;
    } finally {
      savingUser = false;
      notifyListeners();
    }
  }

  // =====================================================
  // UPDATE USER
  // =====================================================

  Future<bool> updateUser(User user) async {
    savingUser = true;
    error = null;
    notifyListeners();

    try {
      await repository.update(user);
      await loadUsers();
      return true;
    } catch (e) {
      error = _friendlyError(e);
      notifyListeners();
      return false;
    } finally {
      savingUser = false;
      notifyListeners();
    }
  }

  // =====================================================
  // TOGGLE STATUS (active / disabled)
  // =====================================================

  Future<void> toggleStatus(User user) async {
    final newStatus = user.isActive ? 0 : 1;

    // Optimistic update so the switch feels instant.
    final index = users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      users[index] = user.copyWith(status: newStatus);
      notifyListeners();
    }

    try {
      await repository.setStatus(user.id!, newStatus);
    } catch (e) {
      error = e.toString();
      await loadUsers(); // revert to server truth on failure
    }
  }

  // =====================================================
  // DELETE USER
  // =====================================================

  Future<bool> deleteUser(int id) async {
    try {
      await repository.delete(id);
      users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(Object e) {
    if (e is UsernameTakenException) return e.toString();
    return e.toString();
  }
}