class ReportSummary {
  final int totalBorrowers;
  final int activeBorrowers;

  final int totalLoans;
  final int activeLoans;
  final int completedLoans;

  final double totalPrincipal;
  final double totalInterest;
  final double totalPortfolio;
  final double totalCollected;
  final double outstandingBalance;

  final double todayCollections;
  final double monthlyCollections;

  final double totalExpenses;
  final double netIncome;

  const ReportSummary({
    required this.totalBorrowers,
    required this.activeBorrowers,
    required this.totalLoans,
    required this.activeLoans,
    required this.completedLoans,
    required this.totalPrincipal,
    required this.totalInterest,
    required this.totalPortfolio,
    required this.totalCollected,
    required this.outstandingBalance,
    required this.todayCollections,
    required this.monthlyCollections,
    required this.totalExpenses,
    required this.netIncome,
  });

  factory ReportSummary.empty() {
    return const ReportSummary(
      totalBorrowers: 0,
      activeBorrowers: 0,
      totalLoans: 0,
      activeLoans: 0,
      completedLoans: 0,
      totalPrincipal: 0,
      totalInterest: 0,
      totalPortfolio: 0,
      totalCollected: 0,
      outstandingBalance: 0,
      todayCollections: 0,
      monthlyCollections: 0,
      totalExpenses: 0,
      netIncome: 0,
    );
  }

  factory ReportSummary.fromMap(Map<String, dynamic> map) {
    return ReportSummary(
      totalBorrowers: map['totalBorrowers'] ?? 0,
      activeBorrowers: map['activeBorrowers'] ?? 0,
      totalLoans: map['totalLoans'] ?? 0,
      activeLoans: map['activeLoans'] ?? 0,
      completedLoans: map['completedLoans'] ?? 0,
      totalPrincipal: (map['totalPrincipal'] ?? 0).toDouble(),
      totalInterest: (map['totalInterest'] ?? 0).toDouble(),
      totalPortfolio: (map['totalPortfolio'] ?? 0).toDouble(),
      totalCollected: (map['totalCollected'] ?? 0).toDouble(),
      outstandingBalance: (map['outstandingBalance'] ?? 0).toDouble(),
      todayCollections: (map['todayCollections'] ?? 0).toDouble(),
      monthlyCollections: (map['monthlyCollections'] ?? 0).toDouble(),
      totalExpenses: (map['totalExpenses'] ?? 0).toDouble(),
      netIncome: (map['netIncome'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalBorrowers': totalBorrowers,
      'activeBorrowers': activeBorrowers,
      'totalLoans': totalLoans,
      'activeLoans': activeLoans,
      'completedLoans': completedLoans,
      'totalPrincipal': totalPrincipal,
      'totalInterest': totalInterest,
      'totalPortfolio': totalPortfolio,
      'totalCollected': totalCollected,
      'outstandingBalance': outstandingBalance,
      'todayCollections': todayCollections,
      'monthlyCollections': monthlyCollections,
      'totalExpenses': totalExpenses,
      'netIncome': netIncome,
    };
  }
}