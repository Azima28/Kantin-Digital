/// Data model untuk tabel `canteen_operators`.
///
/// Merepresentasikan data operator/pemilik stan kantin.
class CanteenOperator {
  final String id;
  final String canteenName;
  final double balanceEarned;
  final DateTime? createdAt;

  const CanteenOperator({
    required this.id,
    required this.canteenName,
    this.balanceEarned = 0.0,
    this.createdAt,
  });

  factory CanteenOperator.fromJson(Map<String, dynamic> json) {
    return CanteenOperator(
      id: json['id'] as String,
      canteenName: json['canteen_name'] as String,
      balanceEarned:
          double.tryParse(json['balance_earned']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'canteen_name': canteenName,
        'balance_earned': balanceEarned,
        'created_at': createdAt?.toIso8601String(),
      };

  CanteenOperator copyWith({
    String? id,
    String? canteenName,
    double? balanceEarned,
    DateTime? createdAt,
  }) {
    return CanteenOperator(
      id: id ?? this.id,
      canteenName: canteenName ?? this.canteenName,
      balanceEarned: balanceEarned ?? this.balanceEarned,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'CanteenOperator(id: $id, canteenName: $canteenName, balance: $balanceEarned)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CanteenOperator && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
