class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String role;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:        json['id'] ?? '',
    fullName:  json['full_name'] ?? '',
    phone:     json['phone'] ?? '',
    role:      json['role'] ?? 'student',
    createdAt: json['created_at'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id':         id,
    'full_name':  fullName,
    'phone':      phone,
    'role':       role,
    'created_at': createdAt,
  };

  bool get isAdmin => role == 'admin';
}