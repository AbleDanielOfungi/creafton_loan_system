

class LoanPayment {
  final int? id;

  final int loanId;

  final int? paymentNumber;

  final String? paymentType;

  final double amount;

  final String? dueDate;

  final String? paymentDate;

  final String? nextPaymentDate;

  final String? status;

  final int? receivedBy;

  final String? notes;

  final String? createdAt;

  LoanPayment({
    this.id,

    required this.loanId,

    this.paymentNumber,

    this.paymentType,

    required this.amount,

    this.dueDate,

    this.paymentDate,

    this.nextPaymentDate,

    this.status,

    this.receivedBy,

    this.notes,

    this.createdAt,
  });

  factory LoanPayment.fromMap(Map<String, dynamic> map) {
    return LoanPayment(
      id: map["id"],

      loanId: map["loan_id"],

      paymentNumber: map["payment_number"],

      paymentType: map["payment_type"],

      amount: (map["amount"] ?? 0).toDouble(),

      dueDate: map["due_date"],

      paymentDate: map["payment_date"],

      nextPaymentDate: map["next_payment_date"],

      status: map["status"],

      receivedBy: map["received_by"],

      notes: map["notes"],

      createdAt: map["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "loan_id": loanId,

      "payment_number": paymentNumber,

      "payment_type": paymentType,

      "amount": amount,

      "due_date": dueDate,

      "payment_date": paymentDate,

      "next_payment_date": nextPaymentDate,

      "status": status,

      "received_by": receivedBy,

      "notes": notes,

      "created_at": createdAt,
    };
  }
}
