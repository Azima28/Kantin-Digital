import 'package:kantin_digital/core/models/user_profile.dart';
import 'package:kantin_digital/core/models/product.dart';
import 'package:kantin_digital/core/models/operator_transaction.dart';

/// Model gabungan untuk detail merchant di panel admin.
///
/// Berisi profile, data operator, katalog produk, transaksi terbaru,
/// dan metrik penjualan (harian + bulanan).
class AdminMerchantDetail {
  final UserProfile profile;
  final Map<String, dynamic> operator;
  final List<Product> products;
  final List<OperatorTransaction> recentTransactions;
  final double dailySales;
  final double monthlySales;

  const AdminMerchantDetail({
    required this.profile,
    this.operator = const {},
    this.products = const [],
    this.recentTransactions = const [],
    this.dailySales = 0.0,
    this.monthlySales = 0.0,
  });

  /// Parse dari query admin_merchant_detail_provider.
  factory AdminMerchantDetail.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'];
    final operatorData = json['operator'];
    final productsData = json['products'] as List<dynamic>? ?? [];
    final txsData = json['transactions'] as List<dynamic>? ?? [];

    return AdminMerchantDetail(
      profile: profileData is Map<String, dynamic>
          ? UserProfile.fromJson(profileData)
          : const UserProfile(id: ''),
      operator: operatorData is Map<String, dynamic> ? operatorData : const {},
      products: productsData
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentTransactions: txsData
          .map((e) => OperatorTransaction.fromOperatorJson(e as Map<String, dynamic>))
          .toList(),
      dailySales: double.tryParse(json['daily_sales_aggregated']?.toString() ?? '0') ?? 0.0,
      monthlySales: double.tryParse(json['monthly_sales_aggregated']?.toString() ?? '0') ?? 0.0,
    );
  }

  int get productCount => products.length;

  String get formattedDailySales =>
      'Rp ${dailySales.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  String get formattedMonthlySales =>
      'Rp ${monthlySales.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';

  @override
  String toString() =>
      'AdminMerchantDetail(name: ${profile.fullName}, products: $productCount)';
}
