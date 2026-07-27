// class Expenditure {
//   final int? id;

//   final int categoryId;

//   final String title;

//   final double amount;

//   final String? paymentMethod;

//   final String? referenceNumber;

//   final String? description;

//   final String expenseDate;

//   final String createdAt;

//   Expenditure({
//     this.id,

//     required this.categoryId,

//     required this.title,

//     required this.amount,

//     this.paymentMethod,

//     this.referenceNumber,

//     this.description,

//     required this.expenseDate,

//     required this.createdAt,
//   });

//   factory Expenditure.fromMap(Map<String, dynamic> map) {
//     return Expenditure(
//       id: map['id'],

//       categoryId: map['category_id'],

//       title: map['title'],

//       amount: map['amount'],

//       paymentMethod: map['payment_method'],

//       referenceNumber: map['reference_number'],

//       description: map['description'],

//       expenseDate: map['expense_date'],

//       createdAt: map['created_at'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,

//       'category_id': categoryId,

//       'title': title,

//       'amount': amount,

//       'payment_method': paymentMethod,

//       'reference_number': referenceNumber,

//       'description': description,

//       'expense_date': expenseDate,

//       'created_at': createdAt,
//     };
//   }
// }



class Expenditure {

  final int? id;

  final int categoryId;

  final String title;

  final double amount;

  final String? paymentMethod;

  final String? referenceNumber;

  final String? description;

  final String expenseDate;

  final String createdAt;



  Expenditure({

    this.id,

    required this.categoryId,

    required this.title,

    required this.amount,

    this.paymentMethod,

    this.referenceNumber,

    this.description,

    required this.expenseDate,

    required this.createdAt,

  });





  // =====================================================
  // SQLITE MAP -> OBJECT
  // =====================================================

  factory Expenditure.fromMap(
      Map<String,dynamic> map){

    return Expenditure(

      id: map['id'],

      categoryId:
      map['category_id'],

      title:
      map['title'] ?? "",

      amount:
      (map['amount'] ?? 0).toDouble(),

      paymentMethod:
      map['payment_method'],

      referenceNumber:
      map['reference_number'],

      description:
      map['description'],

      expenseDate:
      map['expense_date'],

      createdAt:
      map['created_at'],

    );

  }







  // =====================================================
  // OBJECT -> SQLITE MAP
  // =====================================================

  Map<String,dynamic> toMap(){

    return {

      "id":
      id,

      "category_id":
      categoryId,

      "title":
      title,

      "amount":
      amount,

      "payment_method":
      paymentMethod,

      "reference_number":
      referenceNumber,

      "description":
      description,

      "expense_date":
      expenseDate,

      "created_at":
      createdAt,

    };

  }







  // =====================================================
  // COPY WITH
  // =====================================================

  Expenditure copyWith({

    int? id,

    int? categoryId,

    String? title,

    double? amount,

    String? paymentMethod,

    String? referenceNumber,

    String? description,

    String? expenseDate,

    String? createdAt,

  }){


    return Expenditure(

      id:
      id ?? this.id,


      categoryId:
      categoryId ?? this.categoryId,


      title:
      title ?? this.title,


      amount:
      amount ?? this.amount,


      paymentMethod:
      paymentMethod ?? this.paymentMethod,


      referenceNumber:
      referenceNumber ?? this.referenceNumber,


      description:
      description ?? this.description,


      expenseDate:
      expenseDate ?? this.expenseDate,


      createdAt:
      createdAt ?? this.createdAt,


    );


  }


}