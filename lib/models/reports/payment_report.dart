class PaymentReport {
  final int id;

  final int loanId;

  final String loanNumber;

  final int borrowerId;

  final String borrowerName;

  final int paymentNumber;

  final String paymentType;
  final String paymentMethod;

  final double amount;

  final String dueDate;

  final String? paymentDate;

  final String? nextPaymentDate;

  final String status;

  final int? receivedBy;

  final String? receivedByName;

  final String? notes;

  final String? createdAt;

  const PaymentReport({
    required this.id,
    required this.loanId,
    required this.loanNumber,
    required this.borrowerId,
    required this.borrowerName,
    required this.paymentNumber,
    required this.paymentType,
    required this.paymentMethod,
    required this.amount,
    required this.dueDate,
    this.paymentDate,
    this.nextPaymentDate,
    required this.status,
    this.receivedBy,
    this.receivedByName,
    this.notes,
    this.createdAt,
  });

  factory PaymentReport.fromMap(Map<String, dynamic> map) {
    return PaymentReport(
      id: map["id"] ?? 0,

      loanId: map["loan_id"] ?? 0,

      loanNumber: map["loan_number"] ?? "",

      borrowerId: map["borrower_id"] ?? 0,

      borrowerName: map["borrower_name"] ?? "",

      paymentNumber: map["payment_number"] ?? 0,

      paymentType: map["payment_type"] ?? "INSTALLMENT",

      paymentMethod: map["payment_method"] ?? "Cash",

      amount: (map["amount"] ?? 0).toDouble(),

      dueDate: map["due_date"] ?? "",

      paymentDate: map["payment_date"],

      nextPaymentDate: map["next_payment_date"],

      status: map["status"] ?? "PENDING",

      receivedBy: map["received_by"],

      receivedByName: map["received_by_name"],

      notes: map["notes"],

      createdAt: map["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "loan_id": loanId,

      "loan_number": loanNumber,

      "borrower_id": borrowerId,

      "borrower_name": borrowerName,

      "payment_number": paymentNumber,

      "payment_type": paymentType,
      "payment_method": paymentMethod,

      "amount": amount,

      "due_date": dueDate,

      "payment_date": paymentDate,

      "next_payment_date": nextPaymentDate,

      "status": status,

      "received_by": receivedBy,

      "received_by_name": receivedByName,

      "notes": notes,

      "created_at": createdAt,
    };
  }

  PaymentReport copyWith({
    int? id,
    int? loanId,
    String? loanNumber,
    int? borrowerId,
    String? borrowerName,
    int? paymentNumber,
    String? paymentType,
    String? paymentMethod,
    double? amount,
    String? dueDate,
    String? paymentDate,
    String? nextPaymentDate,
    String? status,
    int? receivedBy,
    String? receivedByName,
    String? notes,
    String? createdAt,
  }) {
    return PaymentReport(
      id: id ?? this.id,

      loanId: loanId ?? this.loanId,

      loanNumber: loanNumber ?? this.loanNumber,

      borrowerId: borrowerId ?? this.borrowerId,

      borrowerName: borrowerName ?? this.borrowerName,

      paymentNumber: paymentNumber ?? this.paymentNumber,

      paymentType: paymentType ?? this.paymentType,

      paymentMethod: paymentMethod ?? this.paymentMethod,

      amount: amount ?? this.amount,

      dueDate: dueDate ?? this.dueDate,

      paymentDate: paymentDate ?? this.paymentDate,

      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,

      status: status ?? this.status,

      receivedBy: receivedBy ?? this.receivedBy,

      receivedByName: receivedByName ?? this.receivedByName,

      notes: notes ?? this.notes,

      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isPaid => status.toUpperCase() == "PAID";

  bool get isPending => status.toUpperCase() == "PENDING";

  bool get isOverdue => status.toUpperCase() == "OVERDUE";

  bool get isTodayPayment {
    if (paymentDate == null) return false;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    return paymentDate!.startsWith(today);
  }

  bool get isDueToday {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    return dueDate.startsWith(today);
  }
}
