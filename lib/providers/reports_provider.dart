// import 'package:flutter/material.dart';

// import '../services/reports_service.dart';

// class ReportsProvider extends ChangeNotifier {
//   final ReportsService _service = ReportsService();

//   // ==========================================================
//   // LOADING
//   // ==========================================================

//   bool loading = false;

//   String? error;

//   // ==========================================================
//   // DASHBOARD STATISTICS
//   // ==========================================================

//   Map<String, dynamic> dashboard = {};

//   // ==========================================================
//   // DAILY REPORT
//   // ==========================================================

//   List<Map<String, dynamic>> dailyLoans = [];

//   List<Map<String, dynamic>> dailyPayments = [];

//   List<Map<String, dynamic>> dailyDefaulters = [];

//   // ==========================================================
//   // WEEKLY REPORT
//   // ==========================================================

//   List<Map<String, dynamic>> weeklyLoans = [];

//   List<Map<String, dynamic>> weeklyPayments = [];

//   List<Map<String, dynamic>> weeklyDefaulters = [];


//   String selectedReport = "Daily";

// void changeReport(String report) {
//   selectedReport = report;
//   notifyListeners();
// }

// Future<void> exportPdf() async {}

// Future<void> exportExcel() async {}

// // Future<void> printReport() async {
// //   await exportPdf();
// // }

// Future<void> generateSelectedReport() async {
//   switch (selectedReport) {

//     case "Daily":
//       reportData = await service.generateDailyReport();
//       break;

//     case "Weekly":
//       reportData = await service.generateWeeklyReport();
//       break;

//     case "Monthly":
//       reportData = await service.generateMonthlyReport();
//       break;

//     case "Yearly":
//       reportData = await service.generateYearlyReport();
//       break;

//     case "Custom":
//       reportData = await service.generateCustomReport(
//         from: DateTime.now().subtract(const Duration(days: 30)),
//         to: DateTime.now(),
//       );
//       break;
//   }

//   notifyListeners();
// }

//   // ==========================================================
//   // MONTHLY REPORT
//   // ==========================================================

//   List<Map<String, dynamic>> monthlyLoans = [];

//   List<Map<String, dynamic>> monthlyPayments = [];

//   List<Map<String, dynamic>> monthlyDefaulters = [];

//   // ==========================================================
//   // YEARLY REPORT
//   // ==========================================================

//   List<Map<String, dynamic>> yearlyLoans = [];

//   List<Map<String, dynamic>> yearlyPayments = [];

//   List<Map<String, dynamic>> yearlyDefaulters = [];

//   // ==========================================================
//   // CUSTOM REPORT
//   // ==========================================================

//   List<Map<String, dynamic>> customLoans = [];

//   List<Map<String, dynamic>> customPayments = [];

//   List<Map<String, dynamic>> customDefaulters = [];

//   final ReportsService service = ReportsService();

//   Map<String, dynamic> reportData = {};

//   List<Map<String, dynamic>> loans = [];

//   List<Map<String, dynamic>> payments = [];

//   List<Map<String, dynamic>> defaulters = [];

//   // ==========================================================
//   // LOAD DASHBOARD
//   // ==========================================================

//   Future<void> loadDashboard() async {
//     try {
//       loading = true;
//       error = null;
//       notifyListeners();

//       dashboard = await _service.dashboardStatistics();
//     } catch (e) {
//       error = e.toString();
//     }

//     loading = false;
//     notifyListeners();
//   }

//   // ==========================================================
//   // DAILY REPORT
//   // ==========================================================

//   Future<void> loadDailyReport() async {
//     try {
//       loading = true;
//       notifyListeners();

//       dailyLoans = await _service.dailyLoans();

//       dailyPayments = await _service.dailyPayments();

//       dailyDefaulters = await _service.dailyDefaulters();
//     } catch (e) {
//       error = e.toString();
//     }

//     loading = false;
//     notifyListeners();
//   }

// //   Future<void> generateCustomReport({
// //   required DateTime from,
// //   required DateTime to,
// // }) async {

// //   print("Generate report clicked");

// //   loading = true;
// //   notifyListeners();

// //   try {

// //     reportData = await service.generateCustomReport(
// //       from: from,
// //       to: to,
// //     );

// //     print(reportData);

// //   } finally {

// //     loading = false;
// //     notifyListeners();

// //   }
// // }

//   // ==========================================================
//   // WEEKLY REPORT
//   // ==========================================================

//   Future<void> loadWeeklyReport() async {
//     try {
//       loading = true;
//       notifyListeners();

//       weeklyLoans = await _service.weeklyLoans();

//       weeklyPayments = await _service.weeklyPayments();

//       weeklyDefaulters = await _service.weeklyDefaulters();
//     } catch (e) {
//       error = e.toString();
//     }

//     loading = false;
//     notifyListeners();
//   }

//   // ==========================================================
//   // MONTHLY REPORT
//   // ==========================================================

//   Future<void> loadMonthlyReport() async {
//     try {
//       loading = true;
//       notifyListeners();

//       monthlyLoans = await _service.monthlyLoans();

//       monthlyPayments = await _service.monthlyPayments();

//       monthlyDefaulters = await _service.monthlyDefaulters();
//     } catch (e) {
//       error = e.toString();
//     }

//     loading = false;
//     notifyListeners();
//   }

//   List<double> dailyCollectionTrend = [];

//   List<double> weeklyCollectionTrend = [];

//   List<double> monthlyCollectionTrend = [];

//   List<double> yearlyCollectionTrend = [];

//   List<String> dailyLabels = [];

//   List<String> weeklyLabels = [];

//   List<String> monthlyLabels = [];

//   List<String> yearlyLabels = [];

//   Future<void> loadDailyTrend() async {
//     final result = await _service.dailyCollectionTrend();
//     // final ReportsService service = ReportsService();

//     dailyCollectionTrend = result
//         .map<double>((e) => (e["amount"] as num).toDouble())
//         .toList();

//     dailyLabels = result.map<String>((e) => e["label"].toString()).toList();

//     notifyListeners();
//   }

//   Future<void> loadWeeklyTrend() async {
//     final result = await _service.weeklyCollectionTrend();

//     weeklyCollectionTrend = result
//         .map<double>((e) => (e["amount"] as num).toDouble())
//         .toList();

//     weeklyLabels = result.map<String>((e) => e["label"].toString()).toList();

//     notifyListeners();
//   }

//   Future<void> loadMonthlyTrend() async {
//     final result = await _service.monthlyCollectionTrend();

//     monthlyCollectionTrend = result
//         .map<double>((e) => (e["amount"] as num).toDouble())
//         .toList();

//     monthlyLabels = result.map<String>((e) => e["label"].toString()).toList();

//     notifyListeners();
//   }

//   Future<void> loadYearlyTrend() async {
//     final result = await _service.yearlyCollectionTrend();

//     yearlyCollectionTrend = result
//         .map<double>((e) => (e["amount"] as num).toDouble())
//         .toList();

//     yearlyLabels = result.map<String>((e) => e["label"].toString()).toList();

//     notifyListeners();
//   }
//   // ==========================================================
//   // YEARLY REPORT
//   // ==========================================================

//   Future<void> loadYearlyReport() async {
//     try {
//       loading = true;
//       notifyListeners();

//       yearlyLoans = await _service.yearlyLoans();

//       yearlyPayments = await _service.yearlyPayments();

//       yearlyDefaulters = await _service.yearlyDefaulters();
//     } catch (e) {
//       error = e.toString();
//     }

//     loading = false;
//     notifyListeners();
//   }

//   // ==========================================================
//   // CUSTOM REPORT
//   // ==========================================================

//   Future<void> loadCustomReport(DateTime start, DateTime end) async {
//     try {
//       loading = true;
//       notifyListeners();

//       customLoans = await _service.customLoans(start, end);

//       customPayments = await _service.customPayments(start, end);

//       customDefaulters = await _service.customDefaulters(start, end);
//     } catch (e) {
//       error = e.toString();
//     }

//     loading = false;
//     notifyListeners();
//   }

//   // Future<void> generateCustomReport({
//   //   required DateTime from,
//   //   required DateTime to,
//   // }) async {
//   //   loading = true;
//   //   notifyListeners();

//   //   try {
//   //     reportData = await service.generateCustomReport(from: from, to: to);

//   //     loans = await service.customLoans(from, to);

//   //     payments = await service.customPayments(from, to);

//   //     defaulters = await service.customDefaulters(from, to);

//   //     error = null;
//   //   } catch (e) {
//   //     error = e.toString();
//   //   }

//   //   loading = false;
//   //   notifyListeners();
//   // }


//   Future<void> generateCustomReport({
//   required DateTime from,
//   required DateTime to,
// }) async {

//   print("Generate report clicked");

//   loading = true;
//   notifyListeners();

//   try {

//     reportData = await service.generateCustomReport(
//       from: from,
//       to: to,
//     );

//     print(reportData);

//   } finally {

//     loading = false;
//     notifyListeners();

//   }
// }

//   // ==========================================================
//   // REFRESH
//   // ==========================================================

//   Future<void> refreshDashboard() async {
//     await loadDashboard();
//   }

//   Map<String, dynamic> dashboardSummary = {};

//   Future<void> refreshDaily() async {
//     await loadDailyReport();
//   }

//   Future<void> refreshWeekly() async {
//     await loadWeeklyReport();
//   }

//   Future<void> refreshMonthly() async {
//     await loadMonthlyReport();
//   }

//   Future<void> refreshYearly() async {
//     await loadYearlyReport();
//   }

//   // ==========================================================
//   // TOTALS
//   // ==========================================================

//   double totalLoanAmount(List<Map<String, dynamic>> data) {
//     return data.fold(
//       0,
//       (sum, item) => sum + ((item["total_payable"] ?? 0) as num).toDouble(),
//     );
//   }

//   double totalPrincipal(List<Map<String, dynamic>> data) {
//     return data.fold(
//       0,
//       (sum, item) => sum + ((item["principal_amount"] ?? 0) as num).toDouble(),
//     );
//   }

//   double totalPayments(List<Map<String, dynamic>> data) {
//     return data.fold(
//       0,
//       (sum, item) => sum + ((item["amount"] ?? 0) as num).toDouble(),
//     );
//   }

//   double outstandingBalance(List<Map<String, dynamic>> data) {
//     return data.fold(
//       0,
//       (sum, item) => sum + ((item["remaining_balance"] ?? 0) as num).toDouble(),
//     );
//   }

//   int totalRecords(List<Map<String, dynamic>> data) {
//     return data.length;
//   }

//   // ==========================================================
//   // CLEAR
//   // ==========================================================

//   void clear() {
//     dashboard = {};

//     dailyLoans.clear();
//     dailyPayments.clear();
//     dailyDefaulters.clear();

//     weeklyLoans.clear();
//     weeklyPayments.clear();
//     weeklyDefaulters.clear();

//     monthlyLoans.clear();
//     monthlyPayments.clear();
//     monthlyDefaulters.clear();

//     yearlyLoans.clear();
//     yearlyPayments.clear();
//     yearlyDefaulters.clear();

//     customLoans.clear();
//     customPayments.clear();
//     customDefaulters.clear();

//     notifyListeners();
//   }


// // ======================================================
// // PRINT REPORT
// // ======================================================

// Future<void> printReport() async {

//   // Will call ReportsPdfService in Phase 9.6

//   await exportPdf();

// }

// // ======================================================
// // PRINT REPORT
// // ======================================================



// // ======================================================
// // GENERATE SELECTED REPORT
// // ======================================================

// // Future<void> generateSelectedReport() async {

// //   loading = true;
// //   notifyListeners();

// //   try {

// //     switch (selectedReport) {

// //       case "Daily":

// //         reportData =
// //             await service.generateDailyReport();

// //         break;

// //       case "Weekly":

// //         reportData =
// //             await service.generateWeeklyReport();

// //         break;

// //       case "Monthly":

// //         reportData =
// //             await service.generateMonthlyReport();

// //         break;

// //       case "Yearly":

// //         reportData =
// //             await service.generateYearlyReport();

// //         break;

// //       case "Custom":

// //         // Replace these with the actual filter dates later.
// //         reportData =
// //             await service.generateCustomReport(
// //               from: DateTime.now().subtract(
// //                 const Duration(days: 30),
// //               ),
// //               to: DateTime.now(),
// //             );

// //         break;

// //       default:

// //         reportData =
// //             await service.dashboardSummary();

// //     }

// //   } catch (e) {

// //     error = e.toString();

// //   }

// //   loading = false;
// //   notifyListeners();

// // }
// }



// import 'package:creafton_financial_services/services/reports/report_service.dart';
// import 'package:flutter/foundation.dart';

// import '../models/reports/report_summary.dart';



// enum ReportType {
//   executive,
//   borrowers,
//   loans,
//   payments,
//   arrears,
//   fieldOfficers,
//   expenses,
//   guarantors,
// }

// class ReportProvider extends ChangeNotifier {
//   final ReportService _service = ReportService.instance;

//   //==========================================================
//   // STATE
//   //==========================================================

//   bool _loading = false;
//   String? _error;

//   ReportType _reportType = ReportType.executive;

//   DateTime? _startDate;
//   DateTime? _endDate;

//   int? _borrowerId;
//   int? _fieldOfficerId;

//   String? _loanStatus;

//   ReportSummary _summary = ReportSummary.empty();

//   List<Map<String, dynamic>> _rows = [];

//   DateTime? _lastLoaded;

//   //==========================================================
//   // GETTERS
//   //==========================================================

//   bool get loading => _loading;

//   String? get error => _error;

//   ReportType get reportType => _reportType;

//   DateTime? get startDate => _startDate;

//   DateTime? get endDate => _endDate;

//   int? get borrowerId => _borrowerId;

//   int? get fieldOfficerId => _fieldOfficerId;

//   String? get loanStatus => _loanStatus;

//   ReportSummary get summary => _summary;

//   List<Map<String, dynamic>> get rows =>
//       List.unmodifiable(_rows);

//   DateTime? get lastLoaded => _lastLoaded;

//   //==========================================================
//   // FILTERS
//   //==========================================================

//   void setReportType(ReportType type) {
//     _reportType = type;
//     notifyListeners();
//   }

//   void setDateRange(
//     DateTime? start,
//     DateTime? end,
//   ) {
//     _startDate = start;
//     _endDate = end;
//     notifyListeners();
//   }

//   void setBorrower(int? borrowerId) {
//     _borrowerId = borrowerId;
//     notifyListeners();
//   }

//   void setFieldOfficer(int? officerId) {
//     _fieldOfficerId = officerId;
//     notifyListeners();
//   }

//   void setLoanStatus(String? status) {
//     _loanStatus = status;
//     notifyListeners();
//   }

//   void clearFilters() {
//     _startDate = null;
//     _endDate = null;
//     _borrowerId = null;
//     _fieldOfficerId = null;
//     _loanStatus = null;

//     notifyListeners();
//   }

//   //==========================================================
//   // LOAD REPORT
//   //==========================================================

//   Future<void> loadReport() async {
//     try {
//       _loading = true;
//       _error = null;

//       notifyListeners();

//       switch (_reportType) {
//         case ReportType.executive:
//           _summary = await _service.getExecutiveSummary(
//             startDate: _startDate,
//             endDate: _endDate,
//           );

//           _rows = [];
//           break;

//         case ReportType.borrowers:
//           _rows =
//               await _service.getBorrowersReport();
//           break;

//         case ReportType.loans:
//           _rows =
//               await _service.getLoansReport();
//           break;

//         case ReportType.payments:
//           _rows =
//               await _service.getPaymentsReport();
//           break;

//         case ReportType.arrears:
//           _rows =
//               await _service.getArrearsReport();
//           break;

//         case ReportType.fieldOfficers:
//           _rows =
//               await _service.getFieldOfficerReport();
//           break;

//         case ReportType.expenses:
//           _rows =
//               await _service.getExpenditureReport();
//           break;

//         case ReportType.guarantors:
//           _rows =
//               await _service.getGuarantorReport();
//           break;
//       }

//       _lastLoaded = DateTime.now();
//     } catch (e, stackTrace) {
//       debugPrint(stackTrace.toString());

//       _error = e.toString();
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   //==========================================================
//   // REFRESH
//   //==========================================================

//   Future<void> refresh() async {
//     await loadReport();
//   }

//   //==========================================================
//   // EXPORT PDF
//   //==========================================================

//   Future<void> exportPdf() async {
//     switch (_reportType) {
//       case ReportType.executive:
//         // TODO
//         break;

//       case ReportType.borrowers:
//         // TODO
//         break;

//       case ReportType.loans:
//         // TODO
//         break;

//       case ReportType.payments:
//         // TODO
//         break;

//       case ReportType.arrears:
//         // TODO
//         break;

//       case ReportType.fieldOfficers:
//         // TODO
//         break;

//       case ReportType.expenses:
//         // TODO
//         break;

//       case ReportType.guarantors:
//         // TODO
//         break;
//     }
//   }

//   //==========================================================
//   // PRINT
//   //==========================================================

//   Future<void> printReport() async {
//     // Will call Printing.layoutPdf()
//     // during PDF integration.
//   }

//   //==========================================================
//   // CSV / EXCEL
//   //==========================================================

//   Future<void> exportCsv() async {
//     // Future enhancement.
//   }

//   Future<void> exportExcel() async {
//     // Future enhancement.
//   }
// }