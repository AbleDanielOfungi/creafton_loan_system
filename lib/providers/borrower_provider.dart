
import 'package:flutter/material.dart';

import '../repositories/borrower_repository.dart';
import '../screens/borrowers/borrower.dart';

class BorrowerProvider extends ChangeNotifier {
  final BorrowerRepository repo = BorrowerRepository();

  // =====================================================
  // STATE
  // =====================================================

  List<Borrower> borrowers = [];

  List<Borrower> filteredBorrowers = [];

  Borrower? selectedBorrower;

  bool loading = false;

  String? error;

  // =====================================================
  // LOAD ALL
  // =====================================================

  Future<void> loadBorrowers() async {
    loading = true;
    error = null;

    notifyListeners();

    try {
      borrowers = await repo.getAll();

      filteredBorrowers = List.from(borrowers);
    } catch (e) {
      error = e.toString();
    }

    loading = false;

    notifyListeners();
  }

  // =====================================================
  // GET BORROWER
  // =====================================================

  Future<void> loadBorrower(int id) async {
    loading = true;

    notifyListeners();

    try {
      selectedBorrower = await repo.getById(id);
    } catch (e) {
      error = e.toString();
    }

    loading = false;

    notifyListeners();
  }

  // =====================================================
  // ADD
  // =====================================================

  Future<bool> addBorrower(Borrower borrower) async {
    try {
      await repo.create(borrower);

      await loadBorrowers();

      return true;
    } catch (e) {
      error = e.toString();

      notifyListeners();

      return false;
    }
  }

  // =====================================================
  // UPDATE
  // =====================================================

  Future<bool> updateBorrower(Borrower borrower) async {
    try {
      await repo.update(borrower);

      await loadBorrowers();

      return true;
    } catch (e) {
      error = e.toString();

      notifyListeners();

      return false;
    }
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<bool> deleteBorrower(int id) async {
    try {
      await repo.delete(id);

      await loadBorrowers();

      return true;
    } catch (e) {
      error = e.toString();

      notifyListeners();

      return false;
    }
  }

  // =====================================================
  // SEARCH
  // =====================================================

  Future<void> searchBorrowers(String keyword) async {
    if (keyword.trim().isEmpty) {
      filteredBorrowers = List.from(borrowers);

      notifyListeners();

      return;
    }

    try {
      filteredBorrowers = await repo.search(keyword);
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
  }

  // =====================================================
  // REFRESH
  // =====================================================

  Future<void> refresh() async {
    await loadBorrowers();
  }

  // =====================================================
  // CLEAR SEARCH
  // =====================================================

  void clearSearch() {
    filteredBorrowers = List.from(borrowers);

    notifyListeners();
  }

  // =====================================================
  // CLEAR SELECTED
  // =====================================================

  void clearSelected() {
    selectedBorrower = null;

    notifyListeners();
  }
}
