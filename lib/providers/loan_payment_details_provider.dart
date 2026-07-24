// import 'package:flutter/material.dart';

// import '../models/loan_payment.dart';
// import '../repositories/payment_repository.dart';

// class LoanPaymentDetailsProvider extends ChangeNotifier {
//   final PaymentRepository repository = PaymentRepository();

//   List<LoanPayment> payments = [];

//   double totalPaid = 0;

//   int completedPayments = 0;

//   int pendingPayments = 0;

//   bool loading = false;

//   Future<void> load(int loanId) async {
//     loading = true;

//     notifyListeners();

//     payments = await repository.getLoanPayments(loanId);

//     final stats = await repository.getLoanPaymentStatistics(loanId);

//     totalPaid = (stats["totalPaid"] ?? 0).toDouble();

//     completedPayments = stats["completedPayments"] ?? 0;

//     pendingPayments = stats["pendingPayments"] ?? 0;

//     loading = false;

//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';

import '../models/loan_payment.dart';
import '../repositories/payment_repository.dart';

class LoanPaymentDetailsProvider extends ChangeNotifier {
  final PaymentRepository repository = PaymentRepository();

  List<LoanPayment> payments = [];

  bool loading = false;

  String? error;

  double totalPaid = 0;

  double remainingBalance = 0;

  int paymentCount = 0;

  Future<void> loadPayments(int loanId, double loanBalance) async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      payments = await repository.getPaymentsByLoan(loanId);

      totalPaid = await repository.getLoanTotalPaid(loanId);

      paymentCount = payments.length;

      remainingBalance = loanBalance - totalPaid;

      if (remainingBalance < 0) {
        remainingBalance = 0;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  void clear() {
    payments = [];

    totalPaid = 0;

    remainingBalance = 0;

    paymentCount = 0;

    error = null;

    notifyListeners();
  }
}
