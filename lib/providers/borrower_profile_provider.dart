import 'package:flutter/material.dart';

import '../repositories/borrower_profile_repository.dart';
import '../screens/borrowers/borrower.dart';

class BorrowerProfileProvider extends ChangeNotifier {
  final BorrowerProfileRepository repository = BorrowerProfileRepository();

  Borrower? borrower;

  Map<String, dynamic>? fieldOfficer;

  List<Map<String, dynamic>> loans = [];

  List<Map<String, dynamic>> payments = [];

  List<Map<String, dynamic>> guarantors = [];

  List<Map<String, dynamic>> documents = [];

  Map<String, dynamic>? performance;

  bool loading = false;

  String? error;

  Future<void> loadBorrowerProfile(int borrowerId) async {
    try {
      loading = true;

      error = null;

      notifyListeners();

      borrower = await repository.getBorrowerProfile(borrowerId);

      if (borrower == null) {
        error = "Borrower not found";

        loading = false;

        notifyListeners();

        return;
      }

      fieldOfficer = await repository.getFieldOfficer(borrower!.fieldOfficerId);

      loans = await repository.getBorrowerLoans(borrowerId);

      payments = await repository.getBorrowerPayments(borrowerId);

      guarantors = await repository.getBorrowerGuarantors(borrowerId);

      documents = await repository.getBorrowerDocuments(borrowerId);

      performance = await repository.getBorrowerPerformance(borrowerId);
    } catch (e) {
      error = e.toString();

      debugPrint("Borrower Profile Error: $e");
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  void clear() {
    borrower = null;

    fieldOfficer = null;

    loans = [];

    payments = [];

    guarantors = [];

    documents = [];

    performance = null;

    notifyListeners();
  }
}
