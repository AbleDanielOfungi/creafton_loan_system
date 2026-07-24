import 'package:flutter/material.dart';

import '../models/borrower_statistics.dart';
import '../repositories/borrower_statistics_repository.dart';

class BorrowerStatisticsProvider extends ChangeNotifier {
  final BorrowerStatisticsRepository repository =
      BorrowerStatisticsRepository();

  BorrowerStatistics? statistics;

  bool loading = false;

  String? error;

  // =====================================================
  // LOAD BORROWER STATISTICS
  // =====================================================

  Future<void> loadStatistics(int borrowerId) async {
    try {
      loading = true;

      error = null;

      notifyListeners();

      statistics = await repository.getByBorrower(borrowerId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // CREATE INITIAL STATISTICS
  // =====================================================

  Future<void> createInitial(int borrowerId) async {
    await repository.createInitial(borrowerId);

    await loadStatistics(borrowerId);
  }

  // =====================================================
  // LOAN CREATED
  // =====================================================

  Future<void> addLoan(int borrowerId, double amount) async {
    await repository.addLoan(borrowerId, amount);

    await loadStatistics(borrowerId);
  }

  // =====================================================
  // PAYMENT RECEIVED
  // =====================================================

  Future<void> addPayment(
    int borrowerId,
    double amount,
    String paymentDate,
  ) async {
    await repository.addPayment(borrowerId, amount, paymentDate);

    await loadStatistics(borrowerId);
  }

  // =====================================================
  // COMPLETE LOAN
  // =====================================================

  Future<void> completeLoan(int borrowerId) async {
    await repository.completeLoan(borrowerId);

    await loadStatistics(borrowerId);
  }

  // =====================================================
  // MISSED PAYMENT
  // =====================================================

  Future<void> addMissedPayment(int borrowerId) async {
    await repository.addMissedPayment(borrowerId);

    await loadStatistics(borrowerId);
  }

  // =====================================================
  // LATE PAYMENT
  // =====================================================

  Future<void> addLatePayment(int borrowerId) async {
    await repository.addLatePayment(borrowerId);

    await loadStatistics(borrowerId);
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> delete(int borrowerId) async {
    await repository.delete(borrowerId);

    statistics = null;

    notifyListeners();
  }
}
