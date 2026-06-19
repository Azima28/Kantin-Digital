/// Model gabungan untuk dashboard super admin.
///
/// Berisi ringkasan metrik sistem: jumlah user, total saldo global,
/// volume transaksi harian, dan jumlah transaksi hari ini.
class AdminDashboardData {
  final int userCount;
  final double globalBalance;
  final double dailyVolume;
  final int txCountToday;

  const AdminDashboardData({
    this.userCount = 0,
    this.globalBalance = 0.0,
    this.dailyVolume = 0.0,
    this.txCountToday = 0,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) {
    return AdminDashboardData(
      userCount: (json['user_count'] as num?)?.toInt() ?? 0,
      globalBalance: double.tryParse(json['global_balance']?.toString() ?? '0') ?? 0.0,
      dailyVolume: double.tryParse(json['daily_volume']?.toString() ?? '0') ?? 0.0,
      txCountToday: (json['tx_count_today'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_count': userCount,
        'global_balance': globalBalance,
        'daily_volume': dailyVolume,
        'tx_count_today': txCountToday,
      };

  String get formattedGlobalBalance =>
      'Rp ${globalBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  String get formattedDailyVolume =>
      'Rp ${dailyVolume.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  @override
  String toString() =>
      'AdminDashboardData(users: $userCount, balance: $globalBalance, volume: $dailyVolume)';
}
