class FieldOfficer {

  final int? id;

  final String officerNumber;

  final String fullName;

  final String phone;

  final String? nationalId;

  final String? district;

  final String? address;

  final String status;

  final String? createdAt;



  FieldOfficer({

    this.id,

    required this.officerNumber,

    required this.fullName,

    required this.phone,

    this.nationalId,

    this.district,

    this.address,

    this.status = "ACTIVE",

    this.createdAt,

  });



  factory FieldOfficer.fromMap(
      Map<String,dynamic> map){

    return FieldOfficer(

      id: map['id'],

      officerNumber:
      map['officer_number'],

      fullName:
      map['full_name'],

      phone:
      map['phone'],

      nationalId:
      map['national_id'],

      district:
      map['district'],

      address:
      map['address'],

      status:
      map['status'] ?? "ACTIVE",

      createdAt:
      map['created_at'],

    );

  }





  Map<String,dynamic> toMap(){

    return {

      'id': id,

      'officer_number':
      officerNumber,

      'full_name':
      fullName,

      'phone':
      phone,

      'national_id':
      nationalId,

      'district':
      district,

      'address':
      address,

      'status':
      status,

      'created_at':
      createdAt,

    };

  }






  FieldOfficer copyWith({

    int? id,

    String? officerNumber,

    String? fullName,

    String? phone,

    String? nationalId,

    String? district,

    String? address,

    String? status,

    String? createdAt,

  }){


    return FieldOfficer(

      id: id ?? this.id,

      officerNumber:
      officerNumber ?? this.officerNumber,

      fullName:
      fullName ?? this.fullName,

      phone:
      phone ?? this.phone,

      nationalId:
      nationalId ?? this.nationalId,

      district:
      district ?? this.district,

      address:
      address ?? this.address,

      status:
      status ?? this.status,

      createdAt:
      createdAt ?? this.createdAt,

    );

  }


}