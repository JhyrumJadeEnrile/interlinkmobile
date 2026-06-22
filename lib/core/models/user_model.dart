enum UserRole {
  student,
  teacher,
  supervisor,
  admin,
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final UserRole role;
  final String? profilePicture;
  final String? company;
  final String? department;
  final bool biometricEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePicture,
    this.company,
    this.department,
    this.biometricEnabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: UserRole.student,
      profilePicture: json['profile_picture'] as String?,
      company: json['company'] as String?,
      department: json['department'] as String?,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'role': role.toString(),
        'profile_picture': profilePicture,
        'company': company,
        'department': department,
        'biometric_enabled': biometricEnabled,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    UserRole? role,
    String? profilePicture,
    String? company,
    String? department,
    bool? biometricEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      company: company ?? this.company,
      department: department ?? this.department,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
