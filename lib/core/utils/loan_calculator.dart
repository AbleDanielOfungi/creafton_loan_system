class LoanCalculator {
  static double calculateInterest({
    required double principal,

    required double interestRate,
  }) {
    if (principal <= 0) {
      return 0;
    }

    if (interestRate < 0) {
      return 0;
    }

    return principal * (interestRate / 100);
  }

  static double calculateTotalPayable({
    required double principal,

    required double interestRate,
  }) {
    final interest = calculateInterest(
      principal: principal,

      interestRate: interestRate,
    );

    return principal + interest;
  }

  static double calculateInstallment({
    required double totalPayable,

    required int duration,
  }) {
    if (duration <= 0) {
      return 0;
    }

    return double.parse((totalPayable / duration).toStringAsFixed(2));
  }

  static DateTime calculateEndDate({
    required DateTime startDate,

    required int duration,
  }) {
    return startDate.add(Duration(days: duration));
  }

  static Map<String, dynamic> calculateLoan({
    required double principal,

    required double interestRate,

    required int duration,

    DateTime? startDate,
  }) {
    final start = startDate ?? DateTime.now();

    final interest = calculateInterest(
      principal: principal,

      interestRate: interestRate,
    );

    final total = principal + interest;

    final installment = calculateInstallment(
      totalPayable: total,

      duration: duration,
    );

    final endDate = calculateEndDate(startDate: start, duration: duration);

    return {
      "principal_amount": principal,

      "interest_rate": interestRate,

      "interest_amount": interest,

      "total_payable": total,

      "daily_payment_amount": installment,

      "loan_duration": duration,

      "start_date": start.toIso8601String(),

      "end_date": endDate.toIso8601String(),
    };
  }

  static bool isValidAmount(double amount) {
    return amount > 0;
  }

  static bool isValidInterest(double rate) {
    return rate >= 0;
  }

  static bool isValidDuration(int duration) {
    return duration > 0;
  }
}
