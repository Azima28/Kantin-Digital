/// Data model untuk tabel `balance_adjustments`.
///
/// Mencatat penyesuaian saldo manual oleh admin keuangan.
class BalanceAdjustment {
  final String id;
  final String? studentId;
  final String? transactionTypeId;
  final double amount;
  final String adjustmentType;
  final String? notes;
  final DateTime? createdAt;

  /// Nested object dari join Supabase (opsional).
  final Map<String, dynamic>? transactionType;

  const BalanceAdjustment({
    required this.id,
    this.studentId,
    this.transactionTypeId,
    this.amount = 0.0,
    this.adjustmentType = 'add',
    this.notes,
    this.createdAt,
    this.transactionType,
  });

  factory BalanceAdjustment.fromJson(Map<String, dynamic> json) {
    return BalanceAdjustment(
      id: json['id'] as String,
      studentId: json['student_id'] as String?,
      transactionTypeId: json['transaction_type_id'] as String?,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      adjustmentType: (json['adjustment_type'] as String?) ?? 'add',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      transactionType: json['transaction_type'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'transaction_type_id': transactionTypeId,
        'amount': amount,
        'adjustment_type': adjustmentType,
        'notes': notes,
        'created_at': createdAt?.toIso8601String(),
      };

  bool get isAdd => adjustmentType == 'add';
  bool get isSubtract => adjustmentType == 'subtract';

  /// Nama tipe transaksi dari join data.
  String get typeName {
    if (transactionType != null) {
      return transactionType!['name'] as String? ?? '-';
    }
    return '-';
  }

  @override
  String toString() =>
      'BalanceAdjustment(id: $id, type: $adjustmentType, amount: $amount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BalanceAdjustment && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
