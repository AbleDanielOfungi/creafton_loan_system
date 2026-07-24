import 'package:flutter/material.dart';

import '../models/payment_schedule.dart';

import '../repositories/payment_schedule_repository.dart';

class PaymentScheduleProvider extends ChangeNotifier {
  final repository = PaymentScheduleRepository();

  List<PaymentSchedule> schedule = [];

  bool loading = false;

  String? error;

  Future<void> loadSchedule(int loanId) async {
    loading = true;

    notifyListeners();

    try {
      schedule = await repository.getByLoan(loanId);
    } catch (e) {
      error = e.toString();
    }

    loading = false;

    notifyListeners();
  }

  Future<void> markPaid(int paymentId) async {
    await repository.markPaid(
      paymentId,

      paymentDate: DateTime.now().toIso8601String(),
    );

    notifyListeners();
  }
}
