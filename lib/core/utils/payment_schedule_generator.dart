// class PaymentScheduleGenerator {
//   static List<Map<String, dynamic>> generate({
//     required int loanId,

//     required double dailyPayment,

//     required int duration,

//     required DateTime startDate,
//   }) {
//     List<Map<String, dynamic>> schedule = [];

//     for (int i = 1; i <= duration; i++) {
//       final dueDate = startDate.add(Duration(days: i));

//       schedule.add({
//         "loan_id": loanId,

//         "payment_number": i,

//         "payment_type": "INSTALLMENT",

//         "amount": dailyPayment,

//         "due_date": dueDate.toIso8601String(),

//         "status": "PENDING",

//         "created_at": DateTime.now().toIso8601String(),
//       });
//     }

//     return schedule;
//   }
// }

class PaymentScheduleGenerator {
  static List<Map<String, dynamic>> generate({
    required int loanId,

    required double installmentAmount,

    required int duration,

    required DateTime startDate,

    required String frequency,
  }) {
    final List<Map<String, dynamic>> schedule = [];

    DateTime currentDate = startDate;

    for (int i = 1; i <= duration; i++) {
      currentDate = _nextPaymentDate(currentDate, frequency);

      schedule.add({
        "loan_id": loanId,

        "payment_number": i,

        "payment_type": "INSTALLMENT",

        "amount": installmentAmount,

        "due_date": currentDate.toIso8601String(),

        "payment_date": null,

        "next_payment_date": _nextPaymentDate(
          currentDate,
          frequency,
        ).toIso8601String(),

        "status": "PENDING",

        "created_at": DateTime.now().toIso8601String(),
      });
    }

    return schedule;
  }

  static DateTime _nextPaymentDate(DateTime date, String frequency) {
    switch (frequency) {
      case "WEEKLY":
        return date.add(const Duration(days: 7));

      case "MONTHLY":
        return DateTime(date.year, date.month + 1, date.day);

      case "DAILY":
      default:
        return date.add(const Duration(days: 1));
    }
  }
}
