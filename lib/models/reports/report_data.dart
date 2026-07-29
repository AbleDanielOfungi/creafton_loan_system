import 'borrower_report.dart';
import 'loan_report.dart';
import 'payment_report.dart';
import 'expense_report.dart';
import 'guarantor_report.dart';
import 'field_officer_report.dart';

class ReportData {
  final DateTime generatedAt;

  final DateTime? fromDate;

  final DateTime? toDate;

  final Map<String, dynamic> summary;

  final List<BorrowerReport> borrowers;

  final List<LoanReport> loans;

  final List<PaymentReport> payments;

  final List<ExpenseReport> expenses;

  final List<GuarantorReport> guarantors;

  final List<FieldOfficerReport> fieldOfficers;

  final List<BorrowerReport> defaulters;

  const ReportData({
    required this.generatedAt,
    this.fromDate,
    this.toDate,
    required this.summary,
    required this.borrowers,
    required this.loans,
    required this.payments,
    required this.expenses,
    required this.guarantors,
    required this.fieldOfficers,
    required this.defaulters,
  });

  factory ReportData.empty() {
    return ReportData(
      generatedAt: DateTime.now(),
      summary: {},
      borrowers: const [],
      loans: const [],
      payments: const [],
      expenses: const [],
      guarantors: const [],
      fieldOfficers: const [],
      defaulters: const [],
    );
  }

  ReportData copyWith({
    DateTime? generatedAt,
    DateTime? fromDate,
    DateTime? toDate,
    Map<String, dynamic>? summary,
    List<BorrowerReport>? borrowers,
    List<LoanReport>? loans,
    List<PaymentReport>? payments,
    List<ExpenseReport>? expenses,
    List<GuarantorReport>? guarantors,
    List<FieldOfficerReport>? fieldOfficers,
    List<BorrowerReport>? defaulters,
  }) {
    return ReportData(
      generatedAt: generatedAt ?? this.generatedAt,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      summary: summary ?? this.summary,
      borrowers: borrowers ?? this.borrowers,
      loans: loans ?? this.loans,
      payments: payments ?? this.payments,
      expenses: expenses ?? this.expenses,
      guarantors: guarantors ?? this.guarantors,
      fieldOfficers: fieldOfficers ?? this.fieldOfficers,
      defaulters: defaulters ?? this.defaulters,
    );
  }

  //==========================================================
  // QUICK TOTALS
  //==========================================================

  int get borrowerCount => borrowers.length;

  int get loanCount => loans.length;

  int get paymentCount => payments.length;

  int get expenseCount => expenses.length;

  int get guarantorCount => guarantors.length;

  int get fieldOfficerCount => fieldOfficers.length;

  int get defaulterCount => defaulters.length;

  //==========================================================
  // MONEY TOTALS
  //==========================================================

  double get totalLoanAmount =>
      loans.fold(
        0,
        (sum, e) => sum + e.principalAmount,
      );

  double get totalCollected =>
      payments.fold(
        0,
        (sum, e) => sum + e.amount,
      );

  double get totalExpenses =>
      expenses.fold(
        0,
        (sum, e) => sum + e.amount,
      );

  double get totalOutstanding =>
      loans.fold(
        0,
        (sum, e) => sum + e.remainingBalance,
      );

  double get profit =>
      totalCollected - totalExpenses;

  //==========================================================
  // LOAN COUNTS
  //==========================================================

  int get activeLoans =>
      loans.where((e) => e.isActive).length;

  int get completedLoans =>
      loans.where((e) => e.isCompleted).length;

  int get defaultedLoans =>
      loans.where((e) => e.isDefaulted).length;

  int get overdueLoans =>
      loans.where((e) => e.isOverdue).length;

  //==========================================================
  // PAYMENT COUNTS
  //==========================================================

  int get paidPayments =>
      payments.where((e) => e.isPaid).length;

  int get pendingPayments =>
      payments.where((e) => e.isPending).length;

  int get overduePayments =>
      payments.where((e) => e.isOverdue).length;

  //==========================================================
  // EXPENSE BREAKDOWN
  //==========================================================

  Map<String, double> get expensesByCategory {
    final Map<String, double> data = {};

    for (final expense in expenses) {
      data.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return data;
  }

  //==========================================================
  // COLLECTION BY PAYMENT METHOD
  //==========================================================

  Map<String, double> get collectionsByMethod {
    final Map<String, double> data = {};

    for (final payment in payments) {
      data.update(
        payment.paymentMethod,
        (value) => value + payment.amount,
        ifAbsent: () => payment.amount,
      );
    }

    return data;
  }

  //==========================================================
  // KPI VALUES
  //==========================================================

  double get collectionRate {
    if (totalLoanAmount == 0) {
      return 0;
    }

    return (totalCollected / totalLoanAmount) * 100;
  }

  double get expenseRatio {
    if (totalCollected == 0) {
      return 0;
    }

    return (totalExpenses / totalCollected) * 100;
  }

  double get recoveryRate {
    if (totalLoanAmount == 0) {
      return 0;
    }

    return ((totalLoanAmount - totalOutstanding) /
            totalLoanAmount) *
        100;
  }

  bool get hasData =>
      borrowers.isNotEmpty ||
      loans.isNotEmpty ||
      payments.isNotEmpty ||
      expenses.isNotEmpty;

  bool get isEmpty => !hasData;
}