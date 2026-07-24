class Loan {
  final int? id;

  final String loanNumber;

  final int borrowerId;

  final double principalAmount;

  final double interestRate;

  final double interestAmount;

  final double totalPayable;

  final double remainingBalance;

  final double dailyPaymentAmount;

  final int loanDuration;

  final String paymentFrequency;

  final String startDate;

  final String endDate;

  final String status;

  final String createdAt;

  Loan({
    this.id,

    required this.loanNumber,

    required this.borrowerId,

    required this.principalAmount,

    required this.interestRate,

    required this.interestAmount,

    required this.totalPayable,

    required this.remainingBalance,

    required this.dailyPaymentAmount,

    required this.loanDuration,

    required this.paymentFrequency,

    required this.startDate,

    required this.endDate,

    this.status = "ACTIVE",

    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "loan_number": loanNumber,

      "borrower_id": borrowerId,

      "principal_amount": principalAmount,

      "interest_rate": interestRate,

      "interest_amount": interestAmount,

      "total_payable": totalPayable,

      "remaining_balance": remainingBalance,

      "daily_payment_amount": dailyPaymentAmount,

      "loan_duration": loanDuration,

      "payment_frequency": paymentFrequency,

      "start_date": startDate,

      "end_date": endDate,

      "status": status,

      "created_at": createdAt,
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map["id"],

      loanNumber: map["loan_number"] ?? "",

      borrowerId: map["borrower_id"] ?? 0,

      principalAmount: (map["principal_amount"] ?? 0).toDouble(),

      interestRate: (map["interest_rate"] ?? 0).toDouble(),

      interestAmount: (map["interest_amount"] ?? 0).toDouble(),

      totalPayable: (map["total_payable"] ?? 0).toDouble(),

      remainingBalance: (map["remaining_balance"] ?? 0).toDouble(),

      dailyPaymentAmount: (map["daily_payment_amount"] ?? 0).toDouble(),

      loanDuration: map["loan_duration"] ?? 0,

      paymentFrequency: map["payment_frequency"] ?? "DAILY",

      startDate: map["start_date"] ?? DateTime.now().toIso8601String(),

      endDate: map["end_date"] ?? DateTime.now().toIso8601String(),

      status: map["status"] ?? "ACTIVE",

      createdAt: map["created_at"] ?? DateTime.now().toIso8601String(),
    );
  }

  // ============================
  // HELPERS
  // ============================

  bool get isActive => status == "ACTIVE";

  bool get isCompleted => status == "COMPLETED";

  double get repaymentPercentage {
    if (totalPayable == 0) {
      return 0;
    }

    return ((totalPayable - remainingBalance) / totalPayable) * 100;
  }

  double get interestPercentageAmount {
    if (principalAmount == 0) {
      return 0;
    }

    return (interestAmount / principalAmount) * 100;
  }
}
