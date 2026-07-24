class Borrower {
  final int? id;

  final String borrowerNumber;

  final String fullName;

  final String phone;

  final String? alternativePhone;

  final String? email;

  final String? gender;

  final String? dateOfBirth;

  final String? nationalId;

  final String? district;

  final String? village;

  final String? address;

  final String? occupation;

  final String? businessDetails;

  final String? photo;

  final int? fieldOfficerId;

  final String? nextPaymentDate;

  final String? notes;

  final String status;

  final String createdAt;

  Borrower({
    this.id,

    required this.borrowerNumber,

    required this.fullName,

    required this.phone,

    this.alternativePhone,

    this.email,

    this.gender,

    this.dateOfBirth,

    this.nationalId,

    this.district,

    this.village,

    this.address,

    this.occupation,

    this.businessDetails,

    this.photo,

    this.fieldOfficerId,

    this.nextPaymentDate,

    this.notes,

    this.status = "ACTIVE",

    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "borrower_number": borrowerNumber,

      "full_name": fullName,

      "phone": phone,

      "alternative_phone": alternativePhone,

      "email": email,

      "gender": gender,

      "date_of_birth": dateOfBirth,

      "national_id": nationalId,

      "district": district,

      "village": village,

      "address": address,

      "occupation": occupation,

      "business_details": businessDetails,

      "photo": photo,

      "field_officer_id": fieldOfficerId,

      "next_payment_date": nextPaymentDate,

      "notes": notes,

      "status": status,

      "created_at": createdAt,
    };
  }

  factory Borrower.fromMap(Map<String, dynamic> map) {
    return Borrower(
      id: map["id"],

      borrowerNumber: map["borrower_number"] ?? "",

      fullName: map["full_name"] ?? "",

      phone: map["phone"] ?? "",

      alternativePhone: map["alternative_phone"],

      email: map["email"],

      gender: map["gender"],

      dateOfBirth: map["date_of_birth"],

      nationalId: map["national_id"],

      district: map["district"],

      village: map["village"],

      address: map["address"],

      occupation: map["occupation"],

      businessDetails: map["business_details"],

      photo: map["photo"],

      fieldOfficerId: map["field_officer_id"],

      nextPaymentDate: map["next_payment_date"],

      notes: map["notes"],

      status: map["status"] ?? "ACTIVE",

      createdAt: map["created_at"] ?? "",
    );
  }
}
