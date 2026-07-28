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
  }) async {
    // Repository date-range methods will be added in PHASE 9.3.
    // For now, this returns the current report structure.

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
  // INDIVIDUAL REPORT SECTIONS
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
}