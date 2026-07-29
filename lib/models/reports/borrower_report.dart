class BorrowerReport {
  final int id;

  final String borrowerNumber;

  final String fullName;

  final String phone;

  final String district;

  final String fieldOfficer;

  final String guarantor;

  final String? loanNumber;

  final double principal;

  final double balance;

  final String status;

  const BorrowerReport({
    required this.id,
    required this.borrowerNumber,
    required this.fullName,
    required this.phone,
    required this.district,
    required this.fieldOfficer,
    required this.guarantor,
    this.loanNumber,
    required this.principal,
    required this.balance,
    required this.status,
  });

  factory BorrowerReport.fromMap(Map<String, dynamic> map) {
    return BorrowerReport(
      id: map["id"],
      borrowerNumber: map["borrower_number"] ?? "",
      fullName: map["full_name"] ?? "",
      phone: map["phone"] ?? "",
      district: map["district"] ?? "",
      fieldOfficer: map["field_officer"] ?? "",
      guarantor: map["guarantor"] ?? "",
      loanNumber: map["loan_number"],
      principal: (map["principal_amount"] ?? 0).toDouble(),
      balance: (map["remaining_balance"] ?? 0).toDouble(),
      status: map["loan_status"] ?? "",
    );
  }
}