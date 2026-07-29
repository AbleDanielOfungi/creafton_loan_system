class FieldOfficerReport {
  final int id;

  final String officerNumber;

  final String fullName;

  final String phone;

  final String? nationalId;

  final String? district;

  final String? address;

  final String status;

  final int totalAssignedBorrowers;

  final int activeLoans;

  final int completedLoans;

  final int overdueLoans;

  final double portfolioAmount;

  final double outstandingAmount;

  final double totalCollected;

  final double monthlyCollected;

  final double todayCollected;

  final double recoveryRate;

  final double performanceScore;

  final String? lastUpdated;

  final String? createdAt;

  const FieldOfficerReport({
    required this.id,
    required this.officerNumber,
    required this.fullName,
    required this.phone,
    this.nationalId,
    this.district,
    this.address,
    required this.status,
    required this.totalAssignedBorrowers,
    required this.activeLoans,
    required this.completedLoans,
    required this.overdueLoans,
    required this.portfolioAmount,
    required this.outstandingAmount,
    required this.totalCollected,
    required this.monthlyCollected,
    required this.todayCollected,
    required this.recoveryRate,
    required this.performanceScore,
    this.lastUpdated,
    this.createdAt,
  });

  factory FieldOfficerReport.fromMap(
    Map<String, dynamic> map,
  ) {
    return FieldOfficerReport(
      id: map["id"] ?? 0,

      officerNumber:
          map["officer_number"] ?? "",

      fullName:
          map["full_name"] ?? "",

      phone:
          map["phone"] ?? "",

      nationalId:
          map["national_id"],

      district:
          map["district"],

      address:
          map["address"],

      status:
          map["status"] ?? "ACTIVE",

      totalAssignedBorrowers:
          map["total_assigned"] ?? 0,

      activeLoans:
          map["active_loans"] ?? 0,

      completedLoans:
          map["completed_loans"] ?? 0,

      overdueLoans:
          map["overdue_loans"] ?? 0,

      portfolioAmount:
          (map["portfolio_amount"] ?? 0).toDouble(),

      outstandingAmount:
          (map["outstanding_amount"] ?? 0).toDouble(),

      totalCollected:
          (map["total_collected"] ?? 0).toDouble(),

      monthlyCollected:
          (map["monthly_collected"] ?? 0).toDouble(),

      todayCollected:
          (map["today_collected"] ?? 0).toDouble(),

      recoveryRate:
          (map["recovery_rate"] ?? 0).toDouble(),

      performanceScore:
          (map["performance_score"] ?? 0).toDouble(),

      lastUpdated:
          map["last_updated"],

      createdAt:
          map["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "officer_number": officerNumber,

      "full_name": fullName,

      "phone": phone,

      "national_id": nationalId,

      "district": district,

      "address": address,

      "status": status,

      "total_assigned": totalAssignedBorrowers,

      "active_loans": activeLoans,

      "completed_loans": completedLoans,

      "overdue_loans": overdueLoans,

      "portfolio_amount": portfolioAmount,

      "outstanding_amount": outstandingAmount,

      "total_collected": totalCollected,

      "monthly_collected": monthlyCollected,

      "today_collected": todayCollected,

      "recovery_rate": recoveryRate,

      "performance_score": performanceScore,

      "last_updated": lastUpdated,

      "created_at": createdAt,
    };
  }

  FieldOfficerReport copyWith({
    int? id,
    String? officerNumber,
    String? fullName,
    String? phone,
    String? nationalId,
    String? district,
    String? address,
    String? status,
    int? totalAssignedBorrowers,
    int? activeLoans,
    int? completedLoans,
    int? overdueLoans,
    double? portfolioAmount,
    double? outstandingAmount,
    double? totalCollected,
    double? monthlyCollected,
    double? todayCollected,
    double? recoveryRate,
    double? performanceScore,
    String? lastUpdated,
    String? createdAt,
  }) {
    return FieldOfficerReport(
      id: id ?? this.id,

      officerNumber:
          officerNumber ?? this.officerNumber,

      fullName:
          fullName ?? this.fullName,

      phone:
          phone ?? this.phone,

      nationalId:
          nationalId ?? this.nationalId,

      district:
          district ?? this.district,

      address:
          address ?? this.address,

      status:
          status ?? this.status,

      totalAssignedBorrowers:
          totalAssignedBorrowers ??
              this.totalAssignedBorrowers,

      activeLoans:
          activeLoans ?? this.activeLoans,

      completedLoans:
          completedLoans ??
              this.completedLoans,

      overdueLoans:
          overdueLoans ??
              this.overdueLoans,

      portfolioAmount:
          portfolioAmount ??
              this.portfolioAmount,

      outstandingAmount:
          outstandingAmount ??
              this.outstandingAmount,

      totalCollected:
          totalCollected ??
              this.totalCollected,

      monthlyCollected:
          monthlyCollected ??
              this.monthlyCollected,

      todayCollected:
          todayCollected ??
              this.todayCollected,

      recoveryRate:
          recoveryRate ??
              this.recoveryRate,

      performanceScore:
          performanceScore ??
              this.performanceScore,

      lastUpdated:
          lastUpdated ?? this.lastUpdated,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  //==========================================================
  // Helper Getters
  //==========================================================

  bool get isActive =>
      status.toUpperCase() == "ACTIVE";

  bool get hasPortfolio =>
      portfolioAmount > 0;

  bool get hasOutstanding =>
      outstandingAmount > 0;

  bool get hasOverdueLoans =>
      overdueLoans > 0;

  bool get hasCollections =>
      totalCollected > 0;

  bool get excellentPerformance =>
      performanceScore >= 90;

  bool get goodPerformance =>
      performanceScore >= 75 &&
      performanceScore < 90;

  bool get averagePerformance =>
      performanceScore >= 50 &&
      performanceScore < 75;

  bool get poorPerformance =>
      performanceScore < 50;

  String get performanceGrade {
    if (performanceScore >= 90) return "A+";
    if (performanceScore >= 80) return "A";
    if (performanceScore >= 70) return "B";
    if (performanceScore >= 60) return "C";
    if (performanceScore >= 50) return "D";
    return "F";
  }

  double get collectionEfficiency {
    if (portfolioAmount == 0) return 0;

    return (totalCollected / portfolioAmount) * 100;
  }

  double get outstandingPercentage {
    if (portfolioAmount == 0) return 0;

    return (outstandingAmount / portfolioAmount) * 100;
  }
}