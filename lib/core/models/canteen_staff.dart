/// Data model untuk tabel `canteen_staff`.
class CanteenStaff {
  final String id;
  final String? staffCode;
  final String? position;
  final DateTime? createdAt;

  const CanteenStaff({
    required this.id,
    this.staffCode,
    this.position,
    this.createdAt,
  });

  factory CanteenStaff.fromJson(Map<String, dynamic> json) {
    return CanteenStaff(
      id: json['id'] as String,
      staffCode: json['staff_code'] as String?,
      position: json['position'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'staff_code': staffCode,
        'position': position,
        'created_at': createdAt?.toIso8601String(),
      };

  @override
  String toString() => 'CanteenStaff(id: $id, code: $staffCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CanteenStaff && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
