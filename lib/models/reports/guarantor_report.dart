class GuarantorReport {
  final int id;

  final int borrowerId;

  final String borrowerNumber;

  final String borrowerName;

  final String fullName;

  final String relationship;

  final String? phone;

  final String? nationalId;

  final String? address;

  final String? loanNumber;

  final double? principalAmount;

  final double? remainingBalance;

  final String? loanStatus;

  final String? fieldOfficer;

  final String? createdAt;

  const GuarantorReport({
    required this.id,
    required this.borrowerId,
    required this.borrowerNumber,
    required this.borrowerName,
    required this.fullName,
    required this.relationship,
    this.phone,
    this.nationalId,
    this.address,
    this.loanNumber,
    this.principalAmount,
    this.remainingBalance,
    this.loanStatus,
    this.fieldOfficer,
    this.createdAt,
  });

  factory GuarantorReport.fromMap(
    Map<String, dynamic> map,
  ) {
    return GuarantorReport(
      id: map["id"] ?? 0,

      borrowerId: map["borrower_id"] ?? 0,

      borrowerNumber:
          map["borrower_number"] ?? "",

      borrowerName:
          map["borrower_name"] ?? "",

      fullName:
          map["full_name"] ?? "",

      relationship:
          map["relationship"] ?? "",

      phone:
          map["phone"],

      nationalId:
          map["national_id"],

      address:
          map["address"],

      loanNumber:
          map["loan_number"],

      principalAmount:
          map["principal_amount"] == null
              ? null
              : (map["principal_amount"] as num)
                  .toDouble(),

      remainingBalance:
          map["remaining_balance"] == null
              ? null
              : (map["remaining_balance"] as num)
                  .toDouble(),

      loanStatus:
          map["loan_status"],

      fieldOfficer:
          map["field_officer"],

      createdAt:
          map["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "borrower_id": borrowerId,

      "borrower_number": borrowerNumber,

      "borrower_name": borrowerName,

      "full_name": fullName,

      "relationship": relationship,

      "phone": phone,

      "national_id": nationalId,

      "address": address,

      "loan_number": loanNumber,

      "principal_amount": principalAmount,

      "remaining_balance": remainingBalance,

      "loan_status": loanStatus,

      "field_officer": fieldOfficer,

      "created_at": createdAt,
    };
  }

  GuarantorReport copyWith({
    int? id,
    int? borrowerId,
    String? borrowerNumber,
    String? borrowerName,
    String? fullName,
    String? relationship,
    String? phone,
    String? nationalId,
    String? address,
    String? loanNumber,
    double? principalAmount,
    double? remainingBalance,
    String? loanStatus,
    String? fieldOfficer,
    String? createdAt,
  }) {
    return GuarantorReport(
      id: id ?? this.id,

      borrowerId:
          borrowerId ?? this.borrowerId,

      borrowerNumber:
          borrowerNumber ?? this.borrowerNumber,

      borrowerName:
          borrowerName ?? this.borrowerName,

      fullName:
          fullName ?? this.fullName,

      relationship:
          relationship ?? this.relationship,

      phone:
          phone ?? this.phone,

      nationalId:
          nationalId ?? this.nationalId,

      address:
          address ?? this.address,

      loanNumber:
          loanNumber ?? this.loanNumber,

      principalAmount:
          principalAmount ?? this.principalAmount,

      remainingBalance:
          remainingBalance ??
              this.remainingBalance,

      loanStatus:
          loanStatus ?? this.loanStatus,

      fieldOfficer:
          fieldOfficer ?? this.fieldOfficer,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  //======================================================
  // Helper Getters
  //======================================================

  bool get hasLoan =>
      loanNumber != null &&
      loanNumber!.isNotEmpty;

  bool get hasOutstandingBalance =>
      (remainingBalance ?? 0) > 0;

  bool get isLoanActive =>
      (loanStatus ?? "").toUpperCase() == "ACTIVE";

  bool get isLoanCompleted =>
      (loanStatus ?? "").toUpperCase() == "COMPLETED";

  bool get isLoanDefaulted =>
      (loanStatus ?? "").toUpperCase() == "DEFAULTED";

  bool get hasPhone =>
      phone != null &&
      phone!.trim().isNotEmpty;

  bool get hasNationalId =>
      nationalId != null &&
      nationalId!.trim().isNotEmpty;

  bool get hasAddress =>
      address != null &&
      address!.trim().isNotEmpty;
}