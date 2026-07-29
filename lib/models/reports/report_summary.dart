class ReportSummary {
  final int totalBorrowers;

  final int totalLoans;

  final int activeLoans;

  final int completedLoans;

  final int overdueLoans;

  final int totalGuarantors;

  final int totalFieldOfficers;

  final double principalLent;

  final double interest;

  final double totalPayable;

  final double outstandingBalance;

  final double totalCollected;

  final double totalExpenses;

  final double todayCollections;

  final double todayExpenses;

  final double weeklyCollections;

  final double monthlyCollections;

  final double yearlyCollections;

  const ReportSummary({
    required this.totalBorrowers,
    required this.totalLoans,
    required this.activeLoans,
    required this.completedLoans,
    required this.overdueLoans,
    required this.totalGuarantors,
    required this.totalFieldOfficers,
    required this.principalLent,
    required this.interest,
    required this.totalPayable,
    required this.outstandingBalance,
    required this.totalCollected,
    required this.totalExpenses,
    required this.todayCollections,
    required this.todayExpenses,
    required this.weeklyCollections,
    required this.monthlyCollections,
    required this.yearlyCollections,
  });

  factory ReportSummary.fromMap(Map<String, dynamic> map) {
    return ReportSummary(
      totalBorrowers: map["totalBorrowers"] ?? 0,
      totalLoans: map["totalLoans"] ?? 0,
      activeLoans: map["activeLoans"] ?? 0,
      completedLoans: map["completedLoans"] ?? 0,
      overdueLoans: map["overdueLoans"] ?? 0,
      totalGuarantors: map["totalGuarantors"] ?? 0,
      totalFieldOfficers: map["totalFieldOfficers"] ?? 0,
      principalLent: (map["principalLent"] ?? 0).toDouble(),
      interest: (map["interest"] ?? 0).toDouble(),
      totalPayable: (map["totalPayable"] ?? 0).toDouble(),
      outstandingBalance: (map["outstandingBalance"] ?? 0).toDouble(),
      totalCollected: (map["totalCollected"] ?? 0).toDouble(),
      totalExpenses: (map["totalExpenses"] ?? 0).toDouble(),
      todayCollections: (map["todayCollections"] ?? 0).toDouble(),
      todayExpenses: (map["todayExpenses"] ?? 0).toDouble(),
      weeklyCollections: (map["weeklyCollections"] ?? 0).toDouble(),
      monthlyCollections: (map["monthlyCollections"] ?? 0).toDouble(),
      yearlyCollections: (map["yearlyCollections"] ?? 0).toDouble(),
    );
  }
}