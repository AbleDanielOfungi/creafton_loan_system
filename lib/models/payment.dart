class Payment {
  final int? id;

  final int loanId;

  final int? paymentNumber;

  final double amount;

  final String paymentDate;

  final String paymentType;

  final String? notes;

  final int? receivedBy;

  final String createdAt;

  Payment({
    this.id,

    required this.loanId,

    this.paymentNumber,

    required this.amount,

    required this.paymentDate,

    this.paymentType = "INSTALLMENT",

    this.notes,

    this.receivedBy,

    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "loan_id": loanId,

      "payment_number": paymentNumber,

      "amount": amount,

      "payment_date": paymentDate,

      "payment_type": paymentType,

      "notes": notes,

      "received_by": receivedBy,

      "created_at": createdAt,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map["id"],

      loanId: map["loan_id"],

      paymentNumber: map["payment_number"],

      amount: (map["amount"] as num).toDouble(),

      paymentDate: map["payment_date"],

      paymentType: map["payment_type"] ?? "INSTALLMENT",

      notes: map["notes"],

      receivedBy: map["received_by"],

      createdAt: map["created_at"],
    );
  }
}
