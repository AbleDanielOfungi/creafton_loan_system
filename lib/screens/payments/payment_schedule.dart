class PaymentSchedule {
  final int? id;

  final int loanId;

  final int paymentNumber;

  final double amount;

  final String dueDate;

  final String status;

  PaymentSchedule({
    this.id,

    required this.loanId,

    required this.paymentNumber,

    required this.amount,

    required this.dueDate,

    this.status = "PENDING",
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "loan_id": loanId,

      "payment_number": paymentNumber,

      "amount": amount,

      "due_date": dueDate,

      "status": status,

      "created_at": DateTime.now().toIso8601String(),
    };
  }

  factory PaymentSchedule.fromMap(Map<String, dynamic> map) {
    return PaymentSchedule(
      id: map["id"],

      loanId: map["loan_id"],

      paymentNumber: map["payment_number"],

      amount: map["amount"],

      dueDate: map["due_date"],

      status: map["status"] ?? "PENDING",
    );
  }
}
