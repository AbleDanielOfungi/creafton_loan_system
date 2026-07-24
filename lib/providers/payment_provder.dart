import 'package:flutter/material.dart';

import '../models/loan_payment.dart';
import '../repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository repository = PaymentRepository();

  List<LoanPayment> payments = [];

  List<LoanPayment> recent = [];

  bool loading = false;

  double totalPaid = 0;

  double todayCollection = 0;

  double monthlyCollection = 0;

  int paymentCount = 0;

  String? error;

  // =====================================================
  // LOAD ALL PAYMENTS
  // =====================================================

  Future<void> loadPayments() async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      payments = await repository.getAll();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // LOAD BORROWER PAYMENTS
  // =====================================================

  Future<void> loadBorrowerPayments(int borrowerId) async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      payments = await repository.getPaymentsByBorrower(borrowerId);

      recent = await repository.recentPayments(borrowerId);

      totalPaid = await repository.getTotalPaid(borrowerId);

      paymentCount = await repository.paymentCount(borrowerId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // COLLECTION DASHBOARD
  // =====================================================

  Future<void> loadCollectionStatistics() async {
    try {
      todayCollection = await repository.todayCollection();

      monthlyCollection = await repository.monthlyCollection();

      notifyListeners();
    } catch (e) {
      error = e.toString();

      notifyListeners();
    }
  }

  // =====================================================
  // CREATE PAYMENT
  // =====================================================

  Future<bool> createPayment(LoanPayment payment) async {
    loading = true;

    notifyListeners();

    try {
      await repository.create(payment);

      await loadPayments();

      return true;
    } catch (e) {
      error = e.toString();

      notifyListeners();

      return false;
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // =====================================================
  // DELETE PAYMENT
  // =====================================================

  Future<void> deletePayment(int paymentId) async {
    await repository.delete(paymentId);

    payments.removeWhere((p) => p.id == paymentId);

    notifyListeners();
  }

  // =====================================================
  // CLEAR PROVIDER
  // =====================================================

  void clear() {
    payments = [];

    recent = [];

    totalPaid = 0;

    todayCollection = 0;

    monthlyCollection = 0;

    paymentCount = 0;

    error = null;

    notifyListeners();
  }
}
