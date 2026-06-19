/// Data model untuk tabel `rfid_cards`.
class RfidCard {
  final String uid;
  final String? studentId;
  final String status;
  final DateTime? assignedAt;
  final DateTime? createdAt;

  const RfidCard({
    required this.uid,
    this.studentId,
    this.status = 'active',
    this.assignedAt,
    this.createdAt,
  });

  factory RfidCard.fromJson(Map<String, dynamic> json) {
    return RfidCard(
      uid: json['uid'] as String,
      studentId: json['student_id'] as String?,
      status: (json['status'] as String?) ?? 'active',
      assignedAt: json['assigned_at'] != null
          ? DateTime.tryParse(json['assigned_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'student_id': studentId,
        'status': status,
        'assigned_at': assignedAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
      };

  bool get isActive => status == 'active';
  bool get isAssigned => studentId != null;

  @override
  String toString() => 'RfidCard(uid: $uid, student: $studentId, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RfidCard && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
