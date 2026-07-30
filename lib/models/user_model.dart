class User {
  final int? id;

  final String username;

  final String password;

  final String fullName;

  final String? phone;

  final int? roleId;

  final int status; // 1 = active, 0 = disabled

  final String? createdAt;

  // Populated only when the row comes from a query joined against `roles`.
  // Not a real column on `users`, so it's excluded from toMap().
  final String? roleName;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    this.phone,
    this.roleId,
    this.status = 1,
    this.createdAt,
    this.roleName,
  });

  bool get isActive => status == 1;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      username: map["username"] ?? "",
      password: map["password"] ?? "",
      fullName: map["full_name"] ?? "",
      phone: map["phone"],
      roleId: map["role_id"],
      status: (map["status"] ?? 1) is int
          ? map["status"] ?? 1
          : int.tryParse("${map["status"]}") ?? 1,
      createdAt: map["created_at"],
      roleName: map["role_name"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "full_name": fullName,
      "phone": phone,
      "role_id": roleId,
      "status": status,
      "created_at": createdAt,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    String? phone,
    int? roleId,
    int? status,
    String? createdAt,
    String? roleName,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      roleName: roleName ?? this.roleName,
    );
  }
}

class UserRole {
  final int id;
  final String name;

  UserRole({required this.id, required this.name});

  factory UserRole.fromMap(Map<String, dynamic> map) {
    return UserRole(id: map["id"], name: map["name"] ?? "");
  }
}