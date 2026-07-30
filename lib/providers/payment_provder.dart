// import 'package:flutter/material.dart';

// import '../models/loan_payment.dart';
// import '../repositories/payment_repository.dart';

// class PaymentProvider extends ChangeNotifier {
//   final PaymentRepository repository = PaymentRepository();

//   List<LoanPayment> payments = [];

//   List<LoanPayment> recent = [];

//   bool loading = false;

//   double totalPaid = 0;

//   double todayCollection = 0;

//   double monthlyCollection = 0;

//   int paymentCount = 0;

//   String? error;

//   // =====================================================
//   // LOAD ALL PAYMENTS
//   // =====================================================

//   Future<void> loadPayments() async {
//     loading = true;

//     error = null;

//     notifyListeners();

//     try {
//       payments = await repository.getAll();
//     } catch (e) {
//       error = e.toString();
//     } finally {
//       loading = false;

//       notifyListeners();
//     }
//   }

//   // =====================================================
//   // LOAD BORROWER PAYMENTS
//   // =====================================================

//   Future<void> loadBorrowerPayments(int borrowerId) async {
//     loading = true;

//     error = null;

//     notifyListeners();

//     try {
//       payments = await repository.getPaymentsByBorrower(borrowerId);

//       recent = await repository.recentPayments(borrowerId);

//       totalPaid = await repository.getTotalPaid(borrowerId);

//       paymentCount = await repository.paymentCount(borrowerId);
//     } catch (e) {
//       error = e.toString();
//     } finally {
//       loading = false;

//       notifyListeners();
//     }
//   }

//   // =====================================================
//   // COLLECTION DASHBOARD
//   // =====================================================

//   Future<void> loadCollectionStatistics() async {
//     try {
//       todayCollection = await repository.todayCollection();

//       monthlyCollection = await repository.monthlyCollection();

//       notifyListeners();
//     } catch (e) {
//       error = e.toString();

//       notifyListeners();
//     }
//   }

//   // =====================================================
//   // CREATE PAYMENT
//   // =====================================================

//   Future<bool> createPayment(LoanPayment payment) async {
//     loading = true;

//     notifyListeners();

//     try {
//       await repository.create(payment);

//       await loadPayments();

//       return true;
//     } catch (e) {
//       error = e.toString();

//       notifyListeners();

//       return false;
//     } finally {
//       loading = false;

//       notifyListeners();
//     }
//   }

//   // =====================================================
//   // DELETE PAYMENT
//   // =====================================================

//   Future<void> deletePayment(int paymentId) async {
//     await repository.delete(paymentId);

//     payments.removeWhere((p) => p.id == paymentId);

//     notifyListeners();
//   }

//   // =====================================================
//   // CLEAR PROVIDER
//   // =====================================================

//   void clear() {
//     payments = [];

//     recent = [];

//     totalPaid = 0;

//     todayCollection = 0;

//     monthlyCollection = 0;

//     paymentCount = 0;

//     error = null;

//     notifyListeners();
//   }
// }



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
  // RECORD A PAYMENT AGAINST THE LOAN'S SCHEDULE
  // =====================================================
  //
  // Fills the earliest still-PENDING installment card for this loan
  // (flips it to PAID with today's date) instead of adding a new card.
  // If there is no PENDING installment left (e.g. borrower is paying
  // ahead of schedule or overpaying), it falls back to inserting a new
  // PAID row so the money is still recorded somewhere.
  //
  // Returns true on success. Also updates the loan's remaining_balance
  // and status ('COMPLETED' when it hits zero) as part of the same
  // repository transaction, so callers don't need to update the loan
  // balance separately.

  Future<bool> recordInstallmentPayment({
    required int loanId,
    required double amount,
    required String paymentDate,
    int? receivedBy,
    String? notes,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final pending = await repository.getEarliestPendingInstallment(loanId);

      if (pending != null && pending.id != null) {
        await repository.payInstallment(
          paymentId: pending.id!,
          loanId: loanId,
          amount: amount,
          paymentDate: paymentDate,
          receivedBy: receivedBy,
          notes: notes,
        );
      } else {
        // No scheduled installment left to fill — record as an extra /
        // overpayment row instead of silently dropping the money.
        await repository.create(
          LoanPayment(
            loanId: loanId,
            amount: amount,
            paymentDate: paymentDate,
            status: "PAID",
            paymentType: "EXTRA",
            receivedBy: receivedBy,
            notes: notes ?? "Overpayment / no scheduled installment left",
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      }

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