class Guarantor {

  final int? id;

  final int borrowerId;

  final String fullName;

  final String? relationship;

  final String? phone;

  final String? nationalId;

  final String? address;

  final String? createdAt;



  Guarantor({

    this.id,

    required this.borrowerId,

    required this.fullName,

    this.relationship,

    this.phone,

    this.nationalId,

    this.address,

    this.createdAt,

  });





  // Convert SQLite Map → Object

  factory Guarantor.fromMap(
      Map<String, dynamic> map) {

    return Guarantor(

      id: map['id'],

      borrowerId:
      map['borrower_id'],

      fullName:
      map['full_name'],

      relationship:
      map['relationship'],

      phone:
      map['phone'],

      nationalId:
      map['national_id'],

      address:
      map['address'],

      createdAt:
      map['created_at'],

    );

  }






  // Convert Object → SQLite Map

  Map<String, dynamic> toMap() {

    return {

      'id':
      id,

      'borrower_id':
      borrowerId,

      'full_name':
      fullName,

      'relationship':
      relationship,

      'phone':
      phone,

      'national_id':
      nationalId,

      'address':
      address,

      'created_at':
      createdAt,

    };

  }






  // Copy object with modified values

  Guarantor copyWith({

    int? id,

    int? borrowerId,

    String? fullName,

    String? relationship,

    String? phone,

    String? nationalId,

    String? address,

    String? createdAt,

  }) {


    return Guarantor(

      id:
      id ?? this.id,

      borrowerId:
      borrowerId ?? this.borrowerId,

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

      createdAt:
      createdAt ?? this.createdAt,

    );

  }



}