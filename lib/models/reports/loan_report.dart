class LoanReport {
  final int id;

  final String loanNumber;

  final int borrowerId;

  final String borrowerName;

  final String? fieldOfficer;

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

  final String? createdAt;

  const LoanReport({
    required this.id,
    required this.loanNumber,
    required this.borrowerId,
    required this.borrowerName,
    this.fieldOfficer,
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
    required this.status,
    this.createdAt,
  });

  factory LoanReport.fromMap(Map<String, dynamic> map) {
    return LoanReport(
      id: map["id"] ?? 0,

      loanNumber: map["loan_number"] ?? "",

      borrowerId: map["borrower_id"] ?? 0,

      borrowerName: map["borrower_name"] ?? "",

      fieldOfficer: map["field_officer"],

      principalAmount:
          (map["principal_amount"] ?? 0).toDouble(),

      interestRate:
          (map["interest_rate"] ?? 0).toDouble(),

      interestAmount:
          (map["interest_amount"] ?? 0).toDouble(),

      totalPayable:
          (map["total_payable"] ?? 0).toDouble(),

      remainingBalance:
          (map["remaining_balance"] ?? 0).toDouble(),

      dailyPaymentAmount:
          (map["daily_payment_amount"] ?? 0).toDouble(),

      loanDuration:
          map["loan_duration"] ?? 0,

      paymentFrequency:
          map["payment_frequency"] ?? "DAILY",

      startDate:
          map["start_date"] ?? "",

      endDate:
          map["end_date"] ?? "",

      status:
          map["status"] ?? "ACTIVE",

      createdAt:
          map["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "loan_number": loanNumber,

      "borrower_id": borrowerId,

      "borrower_name": borrowerName,

      "field_officer": fieldOfficer,

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

  LoanReport copyWith({
    int? id,
    String? loanNumber,
    int? borrowerId,
    String? borrowerName,
    String? fieldOfficer,
    double? principalAmount,
    double? interestRate,
    double? interestAmount,
    double? totalPayable,
    double? remainingBalance,
    double? dailyPaymentAmount,
    int? loanDuration,
    String? paymentFrequency,
    String? startDate,
    String? endDate,
    String? status,
    String? createdAt,
  }) {
    return LoanReport(
      id: id ?? this.id,

      loanNumber: loanNumber ?? this.loanNumber,

      borrowerId: borrowerId ?? this.borrowerId,

      borrowerName: borrowerName ?? this.borrowerName,

      fieldOfficer: fieldOfficer ?? this.fieldOfficer,

      principalAmount:
          principalAmount ?? this.principalAmount,

      interestRate:
          interestRate ?? this.interestRate,

      interestAmount:
          interestAmount ?? this.interestAmount,

      totalPayable:
          totalPayable ?? this.totalPayable,

      remainingBalance:
          remainingBalance ?? this.remainingBalance,

      dailyPaymentAmount:
          dailyPaymentAmount ?? this.dailyPaymentAmount,

      loanDuration:
          loanDuration ?? this.loanDuration,

      paymentFrequency:
          paymentFrequency ?? this.paymentFrequency,

      startDate:
          startDate ?? this.startDate,

      endDate:
          endDate ?? this.endDate,

      status:
          status ?? this.status,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  // ==========================================================
  // DERIVED PROPERTIES
  // ==========================================================

  double get amountPaid =>
      totalPayable - remainingBalance;

  double get completionPercentage {
    if (totalPayable <= 0) {
      return 0;
    }

    return (amountPaid / totalPayable) * 100;
  }

  bool get isActive =>
      status.toUpperCase() == "ACTIVE";

  bool get isCompleted =>
      status.toUpperCase() == "COMPLETED";

  bool get isDefaulted =>
      status.toUpperCase() == "DEFAULTED";

  bool get isOverdue =>
      status.toUpperCase() == "OVERDUE";

  bool get hasBalance =>
      remainingBalance > 0;

  bool get isFullyPaid =>
      remainingBalance <= 0;

  String get formattedStatus {
    switch (status.toUpperCase()) {
      case "ACTIVE":
        return "Active";

      case "COMPLETED":
        return "Completed";

      case "DEFAULTED":
        return "Defaulted";

      case "OVERDUE":
        return "Overdue";

      default:
        return status;
    }
  }

  @override
  String toString() {
    return 'LoanReport('
        'loanNumber: $loanNumber, '
        'borrower: $borrowerName, '
        'principal: $principalAmount, '
        'remaining: $remainingBalance, '
        'status: $status'
        ')';
  }
}