class LoanPaymentStatistics {
  final double totalPaid;

  final double remainingBalance;

  final int totalPayments;

  final int completedPayments;

  final int pendingPayments;

  final int overduePayments;

  final double paymentProgress;

  LoanPaymentStatistics({
    required this.totalPaid,

    required this.remainingBalance,

    required this.totalPayments,

    required this.completedPayments,

    required this.pendingPayments,

    required this.overduePayments,

    required this.paymentProgress,
  });
}
