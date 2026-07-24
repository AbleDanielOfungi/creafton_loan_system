class BorrowerStatistics {
  final int? id;

  final int borrowerId;

  final int totalLoans;

  final int activeLoans;

  final int completedLoans;

  final double totalBorrowed;

  final double totalPaid;

  final double outstandingBalance;

  final int totalPayments;

  final int latePayments;

  final int missedPayments;

  final double repaymentScore;

  final String? lastPaymentDate;

  final String createdAt;

  BorrowerStatistics({
    this.id,
    required this.borrowerId,
    this.totalLoans = 0,
    this.activeLoans = 0,
    this.completedLoans = 0,
    this.totalBorrowed = 0,
    this.totalPaid = 0,
    this.outstandingBalance = 0,
    this.totalPayments = 0,
    this.latePayments = 0,
    this.missedPayments = 0,
    this.repaymentScore = 0,
    this.lastPaymentDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "borrower_id": borrowerId,
      "total_loans": totalLoans,
      "active_loans": activeLoans,
      "completed_loans": completedLoans,
      "total_borrowed": totalBorrowed,
      "total_paid": totalPaid,
      "outstanding_balance": outstandingBalance,
      "total_payments": totalPayments,
      "late_payments": latePayments,
      "missed_payments": missedPayments,
      "repayment_score": repaymentScore,
      "last_payment_date": lastPaymentDate,
      "created_at": createdAt,
    };
  }

  factory BorrowerStatistics.fromMap(Map<String, dynamic> map) {
    return BorrowerStatistics(
      id: map["id"],
      borrowerId: map["borrower_id"],
      totalLoans: map["total_loans"] ?? 0,
      activeLoans: map["active_loans"] ?? 0,
      completedLoans: map["completed_loans"] ?? 0,
      totalBorrowed: (map["total_borrowed"] ?? 0).toDouble(),
      totalPaid: (map["total_paid"] ?? 0).toDouble(),
      outstandingBalance: (map["outstanding_balance"] ?? 0).toDouble(),
      totalPayments: map["total_payments"] ?? 0,
      latePayments: map["late_payments"] ?? 0,
      missedPayments: map["missed_payments"] ?? 0,
      repaymentScore: (map["repayment_score"] ?? 0).toDouble(),
      lastPaymentDate: map["last_payment_date"],
      createdAt: map["created_at"] ?? "",
    );
  }

  BorrowerStatistics copyWith({
    int? id,
    int? borrowerId,
    int? totalLoans,
    int? activeLoans,
    int? completedLoans,
    double? totalBorrowed,
    double? totalPaid,
    double? outstandingBalance,
    int? totalPayments,
    int? latePayments,
    int? missedPayments,
    double? repaymentScore,
    String? lastPaymentDate,
    String? createdAt,
  }) {
    return BorrowerStatistics(
      id: id ?? this.id,
      borrowerId: borrowerId ?? this.borrowerId,
      totalLoans: totalLoans ?? this.totalLoans,
      activeLoans: activeLoans ?? this.activeLoans,
      completedLoans: completedLoans ?? this.completedLoans,
      totalBorrowed: totalBorrowed ?? this.totalBorrowed,
      totalPaid: totalPaid ?? this.totalPaid,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      totalPayments: totalPayments ?? this.totalPayments,
      latePayments: latePayments ?? this.latePayments,
      missedPayments: missedPayments ?? this.missedPayments,
      repaymentScore: repaymentScore ?? this.repaymentScore,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
