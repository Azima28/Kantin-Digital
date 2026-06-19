/// Data model untuk tabel `profiles`.
///
/// Merepresentasikan semua pengguna sistem (siswa, admin keuangan, kantin).
class UserProfile {
  final String id;
  final String? email;
  final String? fullName;
  final String? username;
  final String? phoneNumber;
  final String? nisn;
  final String? role;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    this.email,
    this.fullName,
    this.username,
    this.phoneNumber,
    this.nisn,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      username: json['username'] as String?,
      phoneNumber: json['phone_number'] as String?,
      nisn: json['nisn'] as String?,
      role: json['role'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'username': username,
        'phone_number': phoneNumber,
        'nisn': nisn,
        'role': role,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// Membuat salinan dengan field yang diubah.
  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? username,
    String? phoneNumber,
    String? nisn,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nisn: nisn ?? this.nisn,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isStudent => role == 'student';
  bool get isKeuangan => role == 'keuangan';
  bool get isCanteen => role == 'canteen';

  @override
  String toString() => 'UserProfile(id: $id, name: $fullName, role: $role)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserProfile && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
