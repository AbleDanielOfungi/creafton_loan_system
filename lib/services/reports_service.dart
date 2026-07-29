
import '../repositories/reports_repository.dart';

class ReportsService {
  final ReportsRepository _repository = ReportsRepository();

  // =====================================================
  // DASHBOARD SUMMARY
  // =====================================================

  Future<Map<String, dynamic>> dashboardSummary() async {
    return {
      "totalBorrowers": await _repository.totalBorrowers(),
      "totalFieldOfficers": await _repository.totalFieldOfficers(),
      "totalGuarantors": await _repository.totalGuarantors(),
      "totalLoans": await _repository.totalLoans(),
      "activeLoans": await _repository.activeLoans(),
      "completedLoans": await _repository.completedLoans(),
      "overdueLoans": await _repository.overdueLoans(),
      "principalLent": await _repository.totalPrincipalLent(),
      "interest": await _repository.totalInterest(),
      "totalPayable": await _repository.totalPayable(),
      "outstandingBalance": await _repository.outstandingBalance(),
      "totalCollected": await _repository.totalCollected(),
      "totalExpenses": await _repository.totalExpenses(),
      "todayCollections": await _repository.todayCollections(),
      "todayExpenses": await _repository.todayExpenses(),
      "weeklyCollections": await _repository.weeklyCollections(),
      "monthlyCollections": await _repository.monthlyCollections(),
      "yearlyCollections": await _repository.yearlyCollections(),
    };
  }

  /// Compatibility method
  Future<Map<String, dynamic>> dashboardStatistics() async {
    return await dashboardSummary();
  }

  // =====================================================
  // DAILY REPORT
  // =====================================================

  Future<Map<String, dynamic>> generateDailyReport() async {
    return {
      "summary": await dashboardSummary(),
      "loansDueToday": await _repository.loansDueToday(),
      "upcomingPayments": await _repository.upcomingPayments(),
      "defaulters": await _repository.defaulters(),
      "borrowers": await _repository.borrowerReport(),
      "fieldOfficers": await _repository.fieldOfficerPerformance(),
      "expenses": await _repository.expenditureReport(),
    };
  }

  // =====================================================
  // WEEKLY REPORT
  // =====================================================

  Future<Map<String, dynamic>> generateWeeklyReport() async {
    return {
      "summary": await dashboardSummary(),
      "borrowers": await _repository.borrowerReport(),
      "defaulters": await _repository.defaulters(),
      "fieldOfficers": await _repository.fieldOfficerPerformance(),
      "expenses": await _repository.expenditureReport(),
    };
  }

  // =====================================================
  // MONTHLY REPORT
  // =====================================================

  Future<Map<String, dynamic>> generateMonthlyReport() async {
    return {
      "summary": await dashboardSummary(),
      "borrowers": await _repository.borrowerReport(),
      "defaulters": await _repository.defaulters(),
      "fieldOfficers": await _repository.fieldOfficerPerformance(),
      "expenses": await _repository.expenditureReport(),
    };
  }

  // =====================================================
  // YEARLY REPORT
  // =====================================================

  Future<Map<String, dynamic>> generateYearlyReport() async {
    return {
      "summary": await dashboardSummary(),
      "borrowers": await _repository.borrowerReport(),
      "defaulters": await _repository.defaulters(),
      "fieldOfficers": await _repository.fieldOfficerPerformance(),
      "expenses": await _repository.expenditureReport(),
    };
  }

  // =====================================================
  // CUSTOM REPORT
  // =====================================================

  Future<Map<String, dynamic>> generateCustomReport({
    required DateTime from,
    required DateTime to,

  int? borrowerId,
  int? fieldOfficerId,
  String? loanStatus,
  String? paymentStatus,
  String? reportCategory,
  }) async {
    return {
      "from": from,
      "to": to,
      "summary": await dashboardSummary(),
      "borrowers": await _repository.borrowerReport(),
      "fieldOfficers": await _repository.fieldOfficerPerformance(),
      "expenses": await _repository.expenditureReport(),
      "defaulters": await _repository.defaulters(),
    };
  }

  // =====================================================
  // INDIVIDUAL REPORTS
  // =====================================================

  Future<List<Map<String, dynamic>>> borrowerReport() async {
    return await _repository.borrowerReport();
  }

  Future<List<Map<String, dynamic>>> fieldOfficerReport() async {
    return await _repository.fieldOfficerPerformance();
  }

  Future<List<Map<String, dynamic>>> expenditureReport() async {
    return await _repository.expenditureReport();
  }

  Future<List<Map<String, dynamic>>> defaultersReport() async {
    return await _repository.defaulters();
  }

  Future<List<Map<String, dynamic>>> loansDueToday() async {
    return await _repository.loansDueToday();
  }

  Future<List<Map<String, dynamic>>> upcomingPayments() async {
    return await _repository.upcomingPayments();
  }

  // =====================================================
  // COMPATIBILITY METHODS
  // =====================================================

  Future<List<Map<String, dynamic>>> dailyLoans() async {
    return await _repository.loansDueToday();
  }

  Future<List<Map<String, dynamic>>> dailyPayments() async {
    return await _repository.upcomingPayments();
  }

  Future<List<Map<String, dynamic>>> dailyDefaulters() async {
    return await _repository.defaulters();
  }

  Future<List<Map<String, dynamic>>> weeklyLoans() async {
    return await _repository.borrowerReport();
  }

  Future<List<Map<String, dynamic>>> weeklyPayments() async {
    return await _repository.upcomingPayments();
  }

  Future<List<Map<String, dynamic>>> weeklyDefaulters() async {
    return await _repository.defaulters();
  }

  Future<List<Map<String, dynamic>>> monthlyLoans() async {
    return await _repository.borrowerReport();
  }

  Future<List<Map<String, dynamic>>> monthlyPayments() async {
    return await _repository.upcomingPayments();
  }

  Future<List<Map<String, dynamic>>> monthlyDefaulters() async {
    return await _repository.defaulters();
  }

  Future<List<Map<String, dynamic>>> yearlyLoans() async {
    return await _repository.borrowerReport();
  }

  Future<List<Map<String, dynamic>>> yearlyPayments() async {
    return await _repository.upcomingPayments();
  }

  Future<List<Map<String, dynamic>>> yearlyDefaulters() async {
    return await _repository.defaulters();
  }

  // =====================================================
  // DASHBOARD STATISTICS
  // =====================================================

  Future<double> moneyLent() async {
    return await _repository.totalPrincipalLent();
  }

  Future<double> moneyCollected() async {
    return await _repository.totalCollected();
  }

  Future<double> outstandingBalance() async {
    return await _repository.outstandingBalance();
  }

  Future<double> totalExpenses() async {
    return await _repository.totalExpenses();
  }

  Future<int> totalBorrowers() async {
    return await _repository.totalBorrowers();
  }

  Future<int> totalLoans() async {
    return await _repository.totalLoans();
  }

  Future<int> activeLoans() async {
    return await _repository.activeLoans();
  }

  Future<int> completedLoans() async {
    return await _repository.completedLoans();
  }

  Future<int> overdueLoans() async {
    return await _repository.overdueLoans();
  }

  Future<int> totalGuarantors() async {
    return await _repository.totalGuarantors();
  }

  Future<int> totalFieldOfficers() async {
    return await _repository.totalFieldOfficers();
  }

  // =====================================================
  // COLLECTION SUMMARY
  // =====================================================

  Future<Map<String, double>> collectionsSummary() async {
    return {
      "today": await _repository.todayCollections(),
      "week": await _repository.weeklyCollections(),
      "month": await _repository.monthlyCollections(),
      "year": await _repository.yearlyCollections(),
    };
  }

  // =====================================================
// CUSTOM DATE RANGE REPORTS
// =====================================================

Future<List<Map<String, dynamic>>> customLoans(
  DateTime from,
  DateTime to,
) async {
  return await _repository.customLoans(from, to);
}

Future<List<Map<String, dynamic>>> customPayments(
  DateTime from,
  DateTime to,
) async {
  return await _repository.customPayments(from, to);
}

Future<List<Map<String, dynamic>>> customDefaulters(
  DateTime from,
  DateTime to,
) async {
  return await _repository.customDefaulters(from, to);
}
// =====================================================
// COLLECTION TREND CHARTS
// =====================================================

Future<List<Map<String, dynamic>>> dailyCollectionTrend() async {
  return await _repository.dailyCollectionTrend();
}

Future<List<Map<String, dynamic>>> weeklyCollectionTrend() async {
  return await _repository.weeklyCollectionTrend();
}

Future<List<Map<String, dynamic>>> monthlyCollectionTrend() async {
  return await _repository.monthlyCollectionTrend();
}

Future<List<Map<String, dynamic>>> yearlyCollectionTrend() async {
  return await _repository.yearlyCollectionTrend();
}
}