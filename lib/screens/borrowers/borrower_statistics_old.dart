class BorrowerStatistics {
  final int activeLoans;
  final int completedLoans;
  final double totalBorrowed;
  final double amountPaid;
  final double outstandingBalance;
  final double performanceScore;
  final int missedPayments;
  final int latePayments;

  const BorrowerStatistics({
    required this.activeLoans,
    required this.completedLoans,
    required this.totalBorrowed,
    required this.amountPaid,
    required this.outstandingBalance,
    required this.performanceScore,
    required this.missedPayments,
    required this.latePayments,
  });
}
