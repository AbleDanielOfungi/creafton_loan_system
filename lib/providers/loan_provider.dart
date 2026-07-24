import 'package:creafton_financial_services/models/loan.dart';
import 'package:flutter/material.dart';

// import '../screens/loans/loan_old.dart';
import '../repositories/loan_repository.dart';

class LoanProvider extends ChangeNotifier {
  final LoanRepository repository = LoanRepository();

  List<Loan> loans = [];

  Loan? currentLoan;

  bool loading = false;

  double outstandingBalance = 0;

  double totalBorrowed = 0;

  double totalPayable = 0;

  int activeLoans = 0;

  int completedLoans = 0;

  String? error;

  // ======================================================
  // LOAD ALL LOANS
  // ======================================================

  Future<void> loadLoans() async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      loans = (await repository.getAllLoans()).cast<Loan>();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // ======================================================
  // LOAD BORROWER LOANS
  // ======================================================

  Future<void> loadBorrowerLoans(int borrowerId) async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      loans = (await repository.getLoansByBorrower(borrowerId)).cast<Loan>();

      currentLoan = (await repository.getCurrentLoan(borrowerId));

      outstandingBalance = await repository.getOutstandingBalance(borrowerId);

      totalBorrowed = await repository.getTotalBorrowed(borrowerId);

      totalPayable = await repository.getTotalPayable(borrowerId);

      activeLoans = await repository.getActiveLoanCount(borrowerId);

      completedLoans = await repository.getCompletedLoanCount(borrowerId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // ======================================================
  // CREATE LOAN
  // ======================================================

  Future<bool> createLoan(Loan loan) async {
    loading = true;

    error = null;

    notifyListeners();

    try {
      await repository.create(loan);

      await loadLoans();

      return true;
    } catch (e) {
      error = e.toString();

      return false;
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  // ======================================================
  // UPDATE BALANCE
  // ======================================================

  Future<void> updateBalance(int loanId, double balance) async {
    await repository.updateBalance(loanId, balance);

    notifyListeners();
  }

  // ======================================================
  // COMPLETE LOAN
  // ======================================================

  Future<void> completeLoan(int loanId) async {
    await repository.completeLoan(loanId);

    notifyListeners();
  }

  // ======================================================
  // UPDATE STATUS
  // ======================================================

  Future<void> updateStatus(int loanId, String status) async {
    await repository.updateStatus(loanId, status);

    notifyListeners();
  }

  // ======================================================
  // DELETE LOAN
  // ======================================================

  Future<void> deleteLoan(int loanId) async {
    await repository.deleteLoan(loanId);

    loans.removeWhere((loan) => loan.id == loanId);

    notifyListeners();
  }

  // ======================================================
  // REFRESH BORROWER LOANS
  // ======================================================

  Future<void> refreshBorrowerLoans(int borrowerId) async {
    await loadBorrowerLoans(borrowerId);
  }

  // ======================================================
  // CLEAR DATA
  // ======================================================

  void clear() {
    loans = [];

    currentLoan = null;

    outstandingBalance = 0;

    totalBorrowed = 0;

    totalPayable = 0;

    activeLoans = 0;

    completedLoans = 0;

    error = null;

    notifyListeners();
  }
}
