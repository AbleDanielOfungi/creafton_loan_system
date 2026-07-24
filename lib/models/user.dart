class User {
  final int? id;

  final String username;

  final String password;

  final String fullName;

  final String? phone;

  final int roleId;

  User({
    this.id,

    required this.username,

    required this.password,

    required this.fullName,

    this.phone,

    required this.roleId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "username": username,

      "password": password,

      "full_name": fullName,

      "phone": phone,

      "role_id": roleId,
    };
  }
}
