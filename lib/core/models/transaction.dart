/// Data model untuk tabel `transactions`.
///
/// Mencatat semua transaksi keuangan kantin (top-up, pembelian, refund).
class Transaction {
  final String id;
  final String? studentId;
  final String? transactionTypeId;
  final String? canteenStaffId;
  final String? rfidUid;
  final double amount;
  final String? description;
  final DateTime createdAt;

  /// Nested object dari join Supabase (opsional).
  final Map<String, dynamic>? transactionType;
  final Map<String, dynamic>? student;

  const Transaction({
    required this.id,
    this.studentId,
    this.transactionTypeId,
    this.canteenStaffId,
    this.rfidUid,
    this.amount = 0.0,
    this.description,
    required this.createdAt,
    this.transactionType,
    this.student,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      studentId: json['student_id'] as String?,
      transactionTypeId: json['transaction_type_id'] as String?,
      canteenStaffId: json['canteen_staff_id'] as String?,
      rfidUid: json['rfid_uid'] as String?,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      transactionType: json['transaction_type'] as Map<String, dynamic>?,
      student: json['student'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'transaction_type_id': transactionTypeId,
        'canteen_staff_id': canteenStaffId,
        'rfid_uid': rfidUid,
        'amount': amount,
        'description': description,
        'created_at': createdAt.toIso8601String(),
      };

  /// Nama tipe transaksi dari join data.
  String get typeName {
    if (transactionType != null) {
      return transactionType!['name'] as String? ?? '-';
    }
    return '-';
  }

  /// Nama siswa dari join data.
  String get studentName {
    if (student != null) {
      return student!['full_name'] as String? ?? '-';
    }
    return '-';
  }

  @override
  String toString() =>
      'Transaction(id: $id, amount: $amount, type: $transactionTypeId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Transaction && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
