class ExpenseReport {
  final int id;

  final int categoryId;

  final String category;

  final String title;

  final double amount;

  final String paymentMethod;

  final String? referenceNumber;

  final String? description;

  final String expenseDate;

  final int? createdBy;

  final String? createdAt;

  const ExpenseReport({
    required this.id,
    required this.categoryId,
    required this.category,
    required this.title,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.description,
    required this.expenseDate,
    this.createdBy,
    this.createdAt,
  });

  factory ExpenseReport.fromMap(
    Map<String, dynamic> map,
  ) {
    return ExpenseReport(
      id: map["id"] ?? 0,

      categoryId: map["category_id"] ?? 0,

      category: map["category"] ?? "",

      title: map["title"] ?? "",

      amount: (map["amount"] ?? 0).toDouble(),

      paymentMethod:
          map["payment_method"] ?? "Cash",

      referenceNumber:
          map["reference_number"],

      description:
          map["description"],

      expenseDate:
          map["expense_date"] ?? "",

      createdBy:
          map["created_by"],

      createdAt:
          map["created_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "category_id": categoryId,

      "category": category,

      "title": title,

      "amount": amount,

      "payment_method": paymentMethod,

      "reference_number": referenceNumber,

      "description": description,

      "expense_date": expenseDate,

      "created_by": createdBy,

      "created_at": createdAt,
    };
  }

  ExpenseReport copyWith({
    int? id,
    int? categoryId,
    String? category,
    String? title,
    double? amount,
    String? paymentMethod,
    String? referenceNumber,
    String? description,
    String? expenseDate,
    int? createdBy,
    String? createdAt,
  }) {
    return ExpenseReport(
      id: id ?? this.id,

      categoryId:
          categoryId ?? this.categoryId,

      category:
          category ?? this.category,

      title:
          title ?? this.title,

      amount:
          amount ?? this.amount,

      paymentMethod:
          paymentMethod ?? this.paymentMethod,

      referenceNumber:
          referenceNumber ??
              this.referenceNumber,

      description:
          description ?? this.description,

      expenseDate:
          expenseDate ?? this.expenseDate,

      createdBy:
          createdBy ?? this.createdBy,

      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  //==========================================================
  // HELPER GETTERS
  //==========================================================

  bool get isCash =>
      paymentMethod.toUpperCase() == "CASH";

  bool get isBank =>
      paymentMethod.toUpperCase() == "BANK";

  bool get isMobileMoney =>
      paymentMethod.toUpperCase() ==
      "MOBILE MONEY";

  DateTime get expenseDateTime =>
      DateTime.tryParse(expenseDate) ??
      DateTime.now();

  bool get isToday {
    final today = DateTime.now();

    return expenseDateTime.year ==
            today.year &&
        expenseDateTime.month ==
            today.month &&
        expenseDateTime.day ==
            today.day;
  }

  bool get isThisMonth {
    final today = DateTime.now();

    return expenseDateTime.year ==
            today.year &&
        expenseDateTime.month ==
            today.month;
  }

  bool get hasReference =>
      referenceNumber != null &&
      referenceNumber!.trim().isNotEmpty;

  bool get hasDescription =>
      description != null &&
      description!.trim().isNotEmpty;
}